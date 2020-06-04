Class {
	#name : #GTEApplication,
	#superclass : #Object,
	#instVars : [
		'participant',
		'domain',
		'started'
	],
	#category : #GraphiteDDS
}

{ #category : #'instance creation' }
GTEApplication >> arcDeltaArrayType [
	^ MDDSTypeDefinition
		named: 'GraphArcDeltaBatch'
		defined:
			{(MDDSFieldDefinition
				name: #version
				type: (MDDSBasicTypeDefinition for: MDDSUInt64Type new)).
			(MDDSFieldDefinition
				name: #deltas
				type:
					(MDDSCollectionTypeDefinition
						for: MDDSArrayType new
						storing: self arcDeltaType))}
]

{ #category : #'instance creation' }
GTEApplication >> arcDeltaType [
	^ MDDSTypeDefinition
		named: 'GraphArcDelta'
		defined:
			{(MDDSFieldDefinition
				name: #operation
				type: (MDDSBasicTypeDefinition for: MDDSInt8Type new)).
			(MDDSFieldDefinition
				name: #referenceNodeOne
				type: (MDDSBasicTypeDefinition for: MDDSInt32Type new)).
			(MDDSFieldDefinition
				name: #referenceNodeTwo
				type: (MDDSBasicTypeDefinition for: MDDSInt32Type new)).
			(MDDSFieldDefinition
				name: #name
				type: (MDDSBasicTypeDefinition for: MDDSStringType new))}
]

{ #category : #'instance creation' }
GTEApplication >> initialize [
	started := false
]

{ #category : #'instance creation' }
GTEApplication >> newCopyGraphNamed: aGraphName [ 
	| graph  nodesTopic arcsTopic subscriptions |
	 
	nodesTopic := domain
		findOrRegisterTopicByName: ('{1}/{2}/dnodes' format: {participant name asString . aGraphName})
		type: 'GraphNodeDeltaBatch'.
	
	arcsTopic := domain
		findOrRegisterTopicByName: ('{1}/{2}/darcs' format: {participant name asString . aGraphName})
		type: 'GraphArcDeltaBatch'.


	graph := GTEOnlineGraph new.
	graph name: aGraphName. 
	graph nodeSubscription: (
	nodesTopic subscriber
		forParticipant: participant
		onRead: [ :value | graph registerNodes: value ]
		onFailure: [ :err | self onFailure: err ]).
		
	graph arcSubscription: (	
	arcsTopic subscriber
		forParticipant: participant
		onRead: [ :value | graph registerArcs: value ]
		onFailure: [ :err | self onFailure: err ]).
		
		
		^ graph

]

{ #category : #'instance creation' }
GTEApplication >> newPublicGraphNamed: aGraphName [ 
	| graph  nodesTopic arcsTopic |
	 
	nodesTopic := domain
		findOrRegisterTopicByName: ('{1}/{2}/dnodes' format: {participant name asString . aGraphName})
		type: 'GraphNodeDeltaBatch'.
	
	arcsTopic := domain
		findOrRegisterTopicByName: ('{1}/{2}/darcs' format: {participant name asString . aGraphName})
		type: 'GraphArcDeltaBatch'.

	graph := GTEPublishingGraph new.
	graph name: aGraphName. 
	graph deltaNodePublication:  (nodesTopic publisher publishing: participant).
	graph deltaArcPublication:  (arcsTopic publisher publishing: participant).
	
	^ graph 
]

{ #category : #'instance creation' }
GTEApplication >> nodeDeltaArrayType [
	^ MDDSTypeDefinition
		named: 'GraphNodeDeltaBatch'
		defined:
			{(MDDSFieldDefinition
				name: #version
				type: (MDDSBasicTypeDefinition for: MDDSUInt64Type new)).
			(MDDSFieldDefinition
				name: #deltas
				type:
					(MDDSCollectionTypeDefinition
						for: MDDSArrayType new
						storing: self nodeDeltaType))}
]

{ #category : #'instance creation' }
GTEApplication >> nodeDeltaType [
		
		| nodeType |
		nodeType := (MDDSTypeDefinition named: 'Node' defined: {
					MDDSFieldDefinition name: #reference type: (MDDSBasicTypeDefinition for: MDDSInt32Type  new) .
					MDDSFieldDefinition name: #type type: (MDDSBasicTypeDefinition for: MDDSStringType new) .
					MDDSFieldDefinition name: #values type: (MDDSBasicTypeDefinition for: MDDSStringType new) .
		}).
		
	^ 	(	MDDSTypeDefinition named: 'GraphNodeDelta' defined: {				
				MDDSFieldDefinition name: #operation type: (MDDSBasicTypeDefinition for: MDDSInt8Type new) .
				MDDSFieldDefinition name: #node type: nodeType .
			}).
]

{ #category : #'instance creation' }
GTEApplication >> onFailure: anError [
	self traceCr: 'Error: ', anError messageText.
	self error: 'Shall we care?' .
]

{ #category : #'instance creation' }
GTEApplication >> startWith: aName myIp: aStringWithIp masterHttpUrl: anUrl [
	aName isEmptyOrNil ifTrue: [ ^ self error: 'Name is compulsory!' ].
	started ifTrue: [ ^ self error: 'Application already started' ].
	
	domain := DDSExternallyDefinedDomain
		onSimpleDDS: anUrl.	" Add the protocol support "
	domain
		addProtocol: (DDSTCPProtocol encoding: MDDSEncoder decoding: MDDSDecoder).
	participant := DDSDomainParticipant
		domain: domain
		name: aName
		ip: aStringWithIp.
	" Register the type definition needed for the comunication "
	domain registerTypeDefinition: self nodeDeltaArrayType.
	domain registerTypeDefinition: self arcDeltaArrayType.
	started := true. 

]

{ #category : #'instance creation' }
GTEApplication >> stop [
	started
		ifFalse: [ ^ self error: 'Application already stopped' ].
	domain finalize.
	participant stopServers.
	domain := nil.
	participant := nil.
	started := false
]
