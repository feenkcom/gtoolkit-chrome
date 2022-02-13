Class {
	#name : #ChromePageDOMDocumentUpdated,
	#superclass : #ChromePageAnnouncement,
	#category : #'Gt4ChromeDevTools-Announcements'
}

{ #category : #testing }
ChromePageDOMDocumentUpdated class >> isForMethod: aMethod [

	^ aMethod = 'DOM.documentUpdated'
]
