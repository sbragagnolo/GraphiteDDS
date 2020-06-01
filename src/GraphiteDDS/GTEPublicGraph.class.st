Class {
	#name : #GTEPublicGraph,
	#superclass : #GTEAdjacencyListGraph,
	#traits : 'GTEPublicGraphTrait',
	#classTraits : 'GTEPublicGraphTrait classTrait',
	#category : #GraphiteDDS
}

{ #category : #'class decoration' }
GTEPublicGraph >> registerRemoveArcsRelatedWith: aNodeRef [
	self
		registerArcDeltaBatches:
			(arcs
				select: [ :a | a nodes includes: aNodeRef ]
				thenCollect: [ :anArc | 
					GTEAddArc new
						one: (anArc at: 1) two: (anArc at: 2) name: anArc name;
						yourself ])
]
