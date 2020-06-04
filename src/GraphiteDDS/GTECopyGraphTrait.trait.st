Trait {
	#name : #GTECopyGraphTrait,
	#instVars : [
		'subscriptions',
		'name',
		'version',
		'nodeSubscription',
		'arcSubscription'
	],
	#category : #GraphiteDDS
}

{ #category : #accessing }
GTECopyGraphTrait >> arcSubscription: aSubscription [
	aSubscription onRead: [ : val | self registerArcs: val ].
	
	arcSubscription := aSubscription. 
	
]

{ #category : #accessing }
GTECopyGraphTrait >> nodeSubscription: aSubscription [
	aSubscription onRead: [ : val | self registerNodes: val ].
	
	nodeSubscription := aSubscription. 
	
]

{ #category : #accessing }
GTECopyGraphTrait >> registerArcs: aVal [
	self halt 
]

{ #category : #accessing }
GTECopyGraphTrait >> registerNodes: val [
	self halt
]
