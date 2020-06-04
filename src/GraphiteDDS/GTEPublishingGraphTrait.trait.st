Trait {
	#name : #GTEPublishingGraphTrait,
	#instVars : [
		'deltaArcPublication',
		'deltaNodePublication',
		'name',
		'version',
		'nodeDeltaBatches',
		'arcDeltaBatches'
	],
	#category : #GraphiteDDS
}

{ #category : #'class decoration' }
GTEPublishingGraphTrait >> addArc: aGTEArc [
	super addArc: aGTEArc.
	self registerAddArc: aGTEArc
]

{ #category : #'class decoration' }
GTEPublishingGraphTrait >> addNode: aNode [
	super addNode: aNode.
	self registerAddNode: aNode
]

{ #category : #accessing }
GTEPublishingGraphTrait >> deltaArcPublication: aPublication [
	deltaArcPublication:= aPublication 
]

{ #category : #accessing }
GTEPublishingGraphTrait >> deltaNodePublication: aPublication [
	deltaNodePublication:= aPublication 
]

{ #category : #convenience }
GTEPublishingGraphTrait >> fillUpArcWelcomeMessage: graphDeltaArray [
	graphDeltaArray
		deltas:
			((GTEDeltaIntrospector new calculateArcOperationsForCreating: self )
				collect: [ :delta | self transformToDDSType: delta ])
]

{ #category : #convenience }
GTEPublishingGraphTrait >> fillUpNodeWelcomeMessage: graphDeltaArray [
	graphDeltaArray
		deltas:
			((GTEDeltaIntrospector new calculateNodeOperationsForCreating: self )
				collect: [ :delta | self transformToDDSType: delta ]) 
]

{ #category : #accessing }
GTEPublishingGraphTrait >> initializeTrait [
	nodeDeltaBatches := OrderedCollection new .
	arcDeltaBatches :=  OrderedCollection new.
	version := 0 .
]

{ #category : #accessing }
GTEPublishingGraphTrait >> name [
	^ name
]

{ #category : #accessing }
GTEPublishingGraphTrait >> name: aName [
	name := aName
]

{ #category : #registering }
GTEPublishingGraphTrait >> publish [
	| nodesToPublish arcsToPublish deltas | 

	nodesToPublish := nodeDeltaBatches copy.
	nodeDeltaBatches removeAll: nodesToPublish.
	arcsToPublish := arcDeltaBatches copy.
	arcDeltaBatches removeAll: arcsToPublish.

	deltaArcPublication 
		publishForAcquitances: [ : v |  
			deltas := arcsToPublish collect: [ :delta | self transformToDDSType: delta ].
			v version: version. 
			v deltas: deltas
		] forNewArrivals: [ : v | 
			self fillUpArcWelcomeMessage: v.
		] .	
	deltaNodePublication 
		publishForAcquitances: [ : v | 
			deltas := (nodesToPublish collect: [ :delta | self transformToDDSType: delta ]).
			v version: version.  
			v deltas: deltas  
		] forNewArrivals: [ : v | 
			self fillUpNodeWelcomeMessage: v.
		] .
	 
	version := version + 1 .
	

]

{ #category : #registering }
GTEPublishingGraphTrait >> registerAddArc: anArc [
	self
		registerArcDeltaBatches:
			{(GTEAddArc new
				one: (anArc at: 1) two: (anArc at: 2) name: anArc name;
				yourself)}
]

{ #category : #registering }
GTEPublishingGraphTrait >> registerAddNode: aNode [
	self
		registerNodeDeltaBatches:
			{(GTEAddNode new
				node: aNode;
				reference: (self referenceTo: aNode);
				yourself)}
]

{ #category : #registering }
GTEPublishingGraphTrait >> registerArcDeltaBatches: aCollection [
	arcDeltaBatches addAll: aCollection
]

{ #category : #registering }
GTEPublishingGraphTrait >> registerNodeDeltaBatches: aCollection [
	nodeDeltaBatches addAll: aCollection
]

{ #category : #registering }
GTEPublishingGraphTrait >> registerRemoveArc: anArc [
	self
		registerArcDeltaBatches:
			{(GTERemoveArc new
				one: (anArc at: 1) two: (anArc at: 2) name: anArc name;
				yourself)}
]

{ #category : #'class decoration' }
GTEPublishingGraphTrait >> registerRemoveArcsRelatedWith: aNodeRef [
	self shouldBeImplemented 
]

{ #category : #registering }
GTEPublishingGraphTrait >> registerRemoveManyNodes: aCollection [
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
GTEPublishingGraphTrait >> registerRemoveNode: aRef [
	self
		registerNodeDeltaBatches:
			{(GTERemoveNode new
				node: (aRef readValueFrom: self);
				reference: aRef;
				yourself)}
]

{ #category : #'class decoration' }
GTEPublishingGraphTrait >> removeAllNodes: aCollection [
	self registerRemoveManyNodes: aCollection.
	super removeAllNodes: aCollection
]

{ #category : #'class decoration' }
GTEPublishingGraphTrait >> removeArc: anArc [
	self registerRemoveArc: anArc.
	super removeArc: anArc
]

{ #category : #'class decoration' }
GTEPublishingGraphTrait >> removeArcsRelatedWith: anObject [
	self registerRemoveArcsRelatedWith: anObject.
	^ super removeArcsRelatedWith: anObject
]

{ #category : #'class decoration' }
GTEPublishingGraphTrait >> removeNode: aNode [
	self registerRemoveNode: aNode.
	super removeNode: aNode. 
	
]

{ #category : #registering }
GTEPublishingGraphTrait >> transformToDDSType: aDelta [
	^ aDelta delegateTo: self
]
