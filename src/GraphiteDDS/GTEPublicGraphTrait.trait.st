Trait {
	#name : #GTEPublicGraphTrait,
	#instVars : [
		'deltaArcPublication',
		'deltaNodePublication',
		'name',
		'graph',
		'nodeDeltaBatches',
		'arcDeltaBatches'
	],
	#category : #GraphiteDDS
}

{ #category : #'class decoration' }
GTEPublicGraphTrait >> addArc: aGTEArc [
	super addArc: aGTEArc.
	self registerAddArc: aGTEArc
]

{ #category : #'class decoration' }
GTEPublicGraphTrait >> addNode: aNode [
	super addNode: aNode.
	self registerAddNode: aNode
]

{ #category : #accessing }
GTEPublicGraphTrait >> deltaArcPublication: aPublication [
	aPublication
		welcomeMessage: [ :graphDeltaArray | self fillUpArcWelcomeMessage:  graphDeltaArray ].
	deltaArcPublication:= aPublication 
]

{ #category : #accessing }
GTEPublicGraphTrait >> deltaNodePublication: aPublication [
	aPublication
		welcomeMessage: [ :graphDeltaArray | self fillUpNodeWelcomeMessage:  graphDeltaArray ].
	deltaNodePublication:= aPublication 
]

{ #category : #convenience }
GTEPublicGraphTrait >> fillUpArcWelcomeMessage: graphDeltaArray [
	graphDeltaArray
		deltas:
			((GTEDeltaIntrospector new calculateArcOperationsForCreating: graph)
				collect: [ :delta | self transformToDDSType: delta ])
]

{ #category : #convenience }
GTEPublicGraphTrait >> fillUpNodeWelcomeMessage: graphDeltaArray [
	graphDeltaArray
		deltas:
			((GTEDeltaIntrospector new calculateNodeOperationsForCreating: graph)
				collect: [ :delta | self transformToDDSType: delta ]) 
]

{ #category : #convenience }
GTEPublicGraphTrait >> fillUpWelcomeMessage: graphDeltaArray [
	graphDeltaArray
		deltas:
			((GTEDeltaIntrospector new calculateOperationsForCreating: graph)
				collect: [ :delta | self transformToDDSType: delta ])
]

{ #category : #accessing }
GTEPublicGraphTrait >> initializeTrait [
	nodeDeltaBatches := OrderedCollection new .
	arcDeltaBatches :=  OrderedCollection new.
]

{ #category : #accessing }
GTEPublicGraphTrait >> publication: aPublication [
	aPublication
		welcomeMessage: [ :graphDeltaArray | self fillUpWelcomeMessage: graphDeltaArray ]
]

{ #category : #registering }
GTEPublicGraphTrait >> publish [
	| nodesToPublish arcsToPublish | 
	nodesToPublish := nodeDeltaBatches copy.
	nodeDeltaBatches removeAll: nodesToPublish.
	arcsToPublish := arcDeltaBatches copy.
	arcDeltaBatches removeAll: arcsToPublish.

	deltaArcPublication publish: [ : v | v deltas: ( nodeDeltaBatches collect: [ :delta | self transformToDDSType: delta ])].	
	deltaNodePublication publish: [ : v | v deltas: (nodesToPublish collect: [ :delta | self transformToDDSType: delta ]) ].
	

]

{ #category : #registering }
GTEPublicGraphTrait >> registerAddArc: anArc [
	self
		registerArcDeltaBatches:
			{(GTEAddArc new
				one: (anArc at: 1) two: (anArc at: 2) name: anArc name;
				yourself)}
]

{ #category : #registering }
GTEPublicGraphTrait >> registerAddNode: aRef [
	self
		registerNodeDeltaBatches:
			{(GTEAddNode new
				node: (aRef readValueFrom: self);
				reference: aRef;
				yourself)}
]

{ #category : #registering }
GTEPublicGraphTrait >> registerArcDeltaBatches: aCollection [
	arcDeltaBatches addAll: aCollection
]

{ #category : #registering }
GTEPublicGraphTrait >> registerNodeDeltaBatches: aCollection [
	nodeDeltaBatches addAll: aCollection
]

{ #category : #registering }
GTEPublicGraphTrait >> registerRemoveArc: anArc [
	self
		registerArcDeltaBatches:
			{(GTERemoveArc new
				one: (anArc at: 1) two: (anArc at: 2) name: anArc name;
				yourself)}
]

{ #category : #'class decoration' }
GTEPublicGraphTrait >> registerRemoveArcsRelatedWith: aNodeRef [
	self shouldBeImplemented 
]

{ #category : #registering }
GTEPublicGraphTrait >> registerRemoveManyNodes: aCollection [
	self
		registerNodeDeltaBatches:
			(aCollection
				collect: [ :ref | 
					GTERemoveNode new
						node: (ref readValueFrom: self);
						reference: ref;
						yourself ])
]

{ #category : #registering }
GTEPublicGraphTrait >> registerRemoveNode: aRef [
	self
		registerNodeDeltaBatches:
			{(GTERemoveNode new
				node: (aRef readValueFrom: self);
				reference: aRef;
				yourself)}
]

{ #category : #'class decoration' }
GTEPublicGraphTrait >> removeAllNodes: aCollection [
	self registerRemoveManyNodes: aCollection.
	super removeAllNodes: aCollection
]

{ #category : #'class decoration' }
GTEPublicGraphTrait >> removeArc: anArc [
	self registerRemoveArc: anArc.
	super removeArc: anArc
]

{ #category : #'class decoration' }
GTEPublicGraphTrait >> removeArcsRelatedWith: anObject [
	self registerRemoveArcsRelatedWith: anObject.
	^ super removeArcsRelatedWith: anObject
]

{ #category : #'class decoration' }
GTEPublicGraphTrait >> removeNode: aNode [
	self registerRemoveNode: aNode.
	super removeNode: aNode. 
	
]

{ #category : #registering }
GTEPublicGraphTrait >> transformToDDSType: aDelta [
	^ aDelta delegateTo: self
]
