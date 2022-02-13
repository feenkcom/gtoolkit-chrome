Extension { #name : #ChromeNode }

{ #category : #'*Gt4ChromeDevTools' }
ChromeNode >> gtChildrenFor: aView [ 
	<gtView>
	
	dictionary ifNil: [ ^ aView empty ].
	
	^ aView columnedTree
		title: 'Children';
		priority: 1;
		items: [ { self } ];
		children: #children;
		column: 'Name' text: #gtChildrenViewText;
		expandUpTo: 2
]

{ #category : #'*Gt4ChromeDevTools' }
ChromeNode >> gtChildrenViewText [

	| aText |
	aText := self nodeName asRopedText.

	self attributes keysAndValuesDo: [ :aName :aValue | 
		aText append: ' ' asRopedText.
		aText append: (aName asRopedText foreground:
				 BrGlamorousColors disabledButtonTextColor).
		aText append: ('="' asRopedText foreground:
				 BrGlamorousColors disabledButtonTextColor).
		aText append: (aValue asRopedText foreground:
				 BrGlamorousColors disabledButtonTextColor).
		aText append:
			('"' asRopedText foreground:
				 BrGlamorousColors disabledButtonTextColor) ].

	aText append: self nodeValue asRopedText.

	^ aText
]

{ #category : #'*Gt4ChromeDevTools' }
ChromeNode >> gtNodeValueFor: aView [

	<gtView>
	dictionary ifNil: [ ^ aView empty ].
	self nodeValue ifEmpty: [ ^ aView empty ].

	^ aView textEditor
		  title: 'Value';
		  priority: 5;
		  glamorousRegularFontAndSize;
		  text: [ self nodeValue ]
]

{ #category : #'*Gt4ChromeDevTools' }
ChromeNode >> gtRawDictonaryFor: aView context: aContext [
	<gtView>
	
	dictionary ifNil: [ ^ aView empty ].
	
	aContext at: #gtTreeExpansionLevel put: 1.
	
	^ aView forward
		title: 'RAW Data';
		priority: 40;
		object: [ dictionary ];
		view: #gtTreeFor:context:
]
