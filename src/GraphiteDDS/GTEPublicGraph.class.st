Class {
	#name : #GTEPublicGraph,
	#superclass : #GTEAdjacencyListGraph,
	#traits : 'GTEPublicGraphTrait',
	#classTraits : 'GTEPublicGraphTrait classTrait',
	#category : #GraphiteDDS
}

{ #category : #'as yet unclassified' }
GTEPublicGraph >> deltaOperationAddArcOne: aGTEUnBoundedReference two: aGTEUnBoundedReference2 name: aString [ 
	| delta |
	delta := GraphArcDelta new.
	delta 
		referenceNodeOne: aGTEUnBoundedReference offset;
		referenceNodeTwo: aGTEUnBoundedReference2 offset;
		name: aString asString; 
		yourself.
	delta operation: GTEAddArc operation.
	^ delta 
]

{ #category : #'as yet unclassified' }
GTEPublicGraph >> deltaOperationAddNode: aNode reference: aGTEUnBoundedReference [
	| delta |
	delta := GraphNodeDelta new.
	delta node
		reference: aGTEUnBoundedReference offset;
		type: aNode class name asString;
		values: aNode asString.
	delta operation: 1.
	^ delta 
]

{ #category : #accessing }
GTEPublicGraph >> initialize [
	super initialize.
	self initializeTrait
]

{ #category : #'class decoration' }
GTEPublicGraph >> registerRemoveArcsRelatedWith: aNodeRef [
	self
		registerArcDeltaBatches:
			(arcs
				select: [ :a | a nodes includes: aNodeRef ]
				thenCollect: [ :anArc | 
					GTEAddArc new
						one: (anArc at: 1) two: (anArc at: 2) name: anArc name;
						yourself ]).
]
