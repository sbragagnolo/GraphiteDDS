Trait {
	#name : #GTEOnlineGraphTrait,
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
GTEOnlineGraphTrait >> arcSubscription: aSubscription [
	aSubscription onRead: [ : val | self registerArcs: val ].
	
	arcSubscription := aSubscription. 
	
]

{ #category : #accessing }
GTEOnlineGraphTrait >> nodeSubscription: aSubscription [
	aSubscription onRead: [ : val | self registerNodes: val ].
	
	nodeSubscription := aSubscription. 
	
]

{ #category : #accessing }
GTEOnlineGraphTrait >> registerArcs: aVal [
	self shouldBeImplemented 
]

{ #category : #accessing }
GTEOnlineGraphTrait >> registerNodes: val [
	self shouldBeImplemented 
]
