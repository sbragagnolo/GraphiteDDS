Class {
	#name : #GTEOnlineGraph,
	#superclass : #GTEAdjacencyListGraph,
	#traits : 'GTEOnlineGraphTrait',
	#classTraits : 'GTEOnlineGraphTrait classTrait',
	#category : #GraphiteDDS
}

{ #category : #accessing }
GTEOnlineGraph >> registerArcs: aVal [
	self subclassResponsibility
]

{ #category : #accessing }
GTEOnlineGraph >> registerNodes: val [
	self subclassResponsibility
]
