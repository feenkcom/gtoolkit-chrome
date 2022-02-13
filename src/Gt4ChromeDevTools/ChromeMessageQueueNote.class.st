Class {
	#name : #ChromeMessageQueueNote,
	#superclass : #Object,
	#instVars : [
		'title',
		'messages',
		'node'
	],
	#category : #'Gt4ChromeDevTools-Notes'
}

{ #category : #printing }
ChromeMessageQueueNote >> gtDisplayOn: aStream [

	self title ifNil: [ 
		super gtDisplayOn: aStream.
		^ self ].

	aStream nextPutAll: self title asString
]

{ #category : #'gt - extensions' }
ChromeMessageQueueNote >> gtMessagesFor: aView [

	<gtView>
	self messages ifNil: [ ^ aView empty ].

	^ aView columnedList
		  title: 'Message Queue';
		  priority: 2;
		  items: [ self messages ];
		  column: 'Index' text: [ :anItem :anIndex | anIndex ] width: 40;
		  column: 'Type' text: #yourself
]

{ #category : #'gt - extensions' }
ChromeMessageQueueNote >> gtRootNodeFor: aView [

	<gtView>
	^ aView columnedTree
		  title: 'Root Node';
		  priority: 1;
		  items: [ self node ifNotNil: #asArray ifNil: [ #(  ) ] ];
		  children: #children;
		  column: 'Name' text: #gtChildrenViewText;
		  expandUpTo: 2
]

{ #category : #accessing }
ChromeMessageQueueNote >> messages [

	^ messages
]

{ #category : #accessing }
ChromeMessageQueueNote >> messages: anObject [

	messages := anObject
]

{ #category : #accessing }
ChromeMessageQueueNote >> node [

	^ node
]

{ #category : #accessing }
ChromeMessageQueueNote >> node: anObject [

	node := anObject
]

{ #category : #printing }
ChromeMessageQueueNote >> printOn: aStream [

	super printOn: aStream.

	self title ifNil: [ ^ self ].

	aStream
		nextPut: $(;
		nextPutAll: self title asString;
		nextPut: $)
]

{ #category : #accessing }
ChromeMessageQueueNote >> title [

	^ title
]

{ #category : #accessing }
ChromeMessageQueueNote >> title: anObject [

	title := anObject
]
