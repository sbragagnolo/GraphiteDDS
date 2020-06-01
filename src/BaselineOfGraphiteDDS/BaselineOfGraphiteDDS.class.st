Class {
	#name : #BaselineOfGraphiteDDS,
	#superclass : #BaselineOf,
	#category : #BaselineOfGraphiteDDS
}

{ #category : #baselines }
BaselineOfGraphiteDDS >> baseline: spec [
	<baseline>
	spec
		for: #common
		do: [ spec
				baseline: 'SimpleDDS'
					with: [ spec repository: 'github://sbragagnolo/SimpleDDS/src' ].
				spec
				baseline: 'Graphite'
					with: [ spec repository: 'github://sbragagnolo/Graphite/src' ].
			spec
				package: #GraphiteDDS with: [ spec requires: #(SimpleDDS Graphite) ].
			spec
				group: 'default' with: #(#GraphiteDDS );
				group: 'core' with: #(#GraphiteDDS) ]
]
