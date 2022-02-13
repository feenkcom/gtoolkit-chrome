Extension { #name : #ChromeFrameLoadingProcessor }

{ #category : #'*Gt4ChromeDevTools' }
ChromeFrameLoadingProcessor >> gtLoadingsFor: aView [

	<gtView>
	loading ifNil: [ ^ aView empty ].

	^ aView columnedList
		  title: 'Loadings';
		  priority: 1;
		  items: [ 
			  (Set new
				   addAll: loading;
				   addAll: stoppedLoading;
				   yourself) asOrderedCollection ];
		  actionUpdateButton;
		  column: 'ID' text: #yourself;
		  column: 'State' text: [ :anID | 
		  | anAmount |
		  anAmount := loading occurrencesOf: anID.
		  anAmount isZero
			  ifFalse: [ 
				  'loading ' asRopedText
					  foreground: BrGlamorousColors errorBackgroundColor;
					  append:
						  ((anAmount asString , ' times') asRopedText foreground:
								   BrGlamorousColors disabledButtonTextColor) ]
			  ifTrue: [ 
				  anAmount := stoppedLoading occurrencesOf: anID.
				  anAmount isZero
					  ifFalse: [ 
						  'stopped loading ' asRopedText
							  foreground: BrGlamorousColors successBackgroundColor;
							  append:
								  ((anAmount asString , ' times') asRopedText foreground:
										   BrGlamorousColors disabledButtonTextColor) ]
					  ifTrue: [ '...' ] ] ]
]

{ #category : #'*Gt4ChromeDevTools' }
ChromeFrameLoadingProcessor >> gtMessageProcessorsViewStateText [

	| aText |
	aText := '' asRopedText.

	loading asSet ifNotEmpty: [ :aSet | 
		| aLoadingText |
		aLoadingText := 'loading ' asRopedText
			                foreground: BrGlamorousColors errorBackgroundColor;
			                append:
				                ((aSet size asString , ' times') asRopedText 
					                 foreground:
						                 BrGlamorousColors disabledButtonTextColor).
		aText append: aLoadingText ].

	stoppedLoading asSet ifNotEmpty: [ :aSet | 
		| aStopText |
		aStopText := 'stopped loading ' asRopedText
			             foreground: BrGlamorousColors successBackgroundColor;
			             append:
				             ((aSet size asString , ' times') asRopedText 
					              foreground:
						              BrGlamorousColors disabledButtonTextColor).

		aText ifNotEmpty: [ 
			aText append: (', ' asRopedText foreground:
					 BrGlamorousColors disabledButtonTextColor) ].

		aText append: aStopText ].

	loadedTimestamp ifNotNil: [ :aTimestamp | 
		| aDuration aTimeText |
		aDuration := DateAndTime now - aTimestamp.
		aTimeText := ('finished ' , aDuration humanReadablePrintString
		              , ' ago') asRopedText.

		aText ifNotEmpty: [ 
			aText append: (', ' asRopedText foreground:
					 BrGlamorousColors disabledButtonTextColor) ].

		aText append: aTimeText ].

	^ aText
]
