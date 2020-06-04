Trait {
	#name : #GTEPublicGraphTrait,
	#instVars : [
		'deltaArcPublication',
		'deltaNodePublication',
		'name',
		'version',
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
	deltaArcPublication:= aPublication 
]

{ #category : #accessing }
GTEPublicGraphTrait >> deltaNodePublication: aPublication [
	deltaNodePublication:= aPublication 
]

{ #category : #convenience }
GTEPublicGraphTrait >> fillUpArcWelcomeMessage: graphDeltaArray [
	graphDeltaArray
		deltas:
			((GTEDeltaIntrospector new calculateArcOperationsForCreating: self )
				collect: [ :delta | self transformToDDSType: delta ])
]

{ #category : #convenience }
GTEPublicGraphTrait >> fillUpNodeWelcomeMessage: graphDeltaArray [
	graphDeltaArray
		deltas:
			((GTEDeltaIntrospector new calculateNodeOperationsForCreating: self )
				collect: [ :delta | self transformToDDSType: delta ]) 
]

{ #category : #accessing }
GTEPublicGraphTrait >> initializeTrait [
	nodeDeltaBatches := OrderedCollection new .
	arcDeltaBatches :=  OrderedCollection new.
	version := 0 .
]

{ #category : #accessing }
GTEPublicGraphTrait >> name [
	^ name
]

{ #category : #accessing }
GTEPublicGraphTrait >> name: aName [
	name := aName
]

{ #category : #registering }
GTEPublicGraphTrait >> publish [
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
GTEPublicGraphTrait >> registerAddArc: anArc [
	self
		registerArcDeltaBatches:
			{(GTEAddArc new
				one: (anArc at: 1) two: (anArc at: 2) name: anArc name;
				yourself)}
]

{ #category : #registering }
GTEPublicGraphTrait >> registerAddNode: aNode [
	self
		registerNodeDeltaBatches:
			{(GTEAddNode new
				node: aNode;
				reference: (self referenceTo: aNode);
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
