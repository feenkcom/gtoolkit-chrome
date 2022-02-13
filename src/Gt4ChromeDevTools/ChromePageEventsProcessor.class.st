Class {
	#name : #ChromePageEventsProcessor,
	#superclass : #ChromeMessageProcessor,
	#instVars : [
		'announcer',
		'page'
	],
	#category : #'Gt4ChromeDevTools-Model'
}

{ #category : #private }
ChromePageEventsProcessor >> announce: anAnnouncement [

	announcer ifNil: [ ^ self ].

	announcer announce: anAnnouncement
]

{ #category : #accessing }
ChromePageEventsProcessor >> gtMessageProcessorsViewStateText [

	(announcer isNil or: [ announcer numberOfSubscriptions isZero ]) 
		ifTrue: [ 
			^ 'without subscriptions' asRopedText foreground:
				  BrGlamorousColors disabledButtonTextColor ].

	^ 'with subscriptions' asRopedText foreground:
		  BrGlamorousColors successBackgroundColor
]

{ #category : #accessing }
ChromePageEventsProcessor >> page [

	^ page
]

{ #category : #accessing }
ChromePageEventsProcessor >> page: anObject [

	page := anObject
]

{ #category : #messages }
ChromePageEventsProcessor >> processMessage: aMessageDictionary [

	| method anAnnouncement |
	announcer ifNil: [ ^ self ].
	method := aMessageDictionary at: 'method' ifAbsent: [ ^ self ].

	anAnnouncement := ChromePageAnnouncement forMethod: method.
	anAnnouncement ifNil: [ ^ self ].

	anAnnouncement
		page: self page;
		message: aMessageDictionary.

	self announce: anAnnouncement.
]

{ #category : #subscriptions }
ChromePageEventsProcessor >> unsubscribe: aReceiver [

	announcer ifNil: [ ^ self ].

	announcer unsubscribe: aReceiver
]

{ #category : #subscriptions }
ChromePageEventsProcessor >> when: anAnnouncement do: aMessage [

	announcer ifNil: [ announcer := Announcer new ].

	^ announcer when: anAnnouncement do: aMessage
]

{ #category : #subscriptions }
ChromePageEventsProcessor >> when: anAnnouncement send: aMessageSelector to: aReceiver [

	announcer ifNil: [ announcer := Announcer new ].

	^ announcer weak
		  when: anAnnouncement
		  send: aMessageSelector
		  to: aReceiver
]
