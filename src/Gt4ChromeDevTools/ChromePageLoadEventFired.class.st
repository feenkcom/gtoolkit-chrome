Class {
	#name : #ChromePageLoadEventFired,
	#superclass : #ChromePageAnnouncement,
	#category : #'Gt4ChromeDevTools-Announcements'
}

{ #category : #testing }
ChromePageLoadEventFired class >> isForMethod: aMethod [

	^ aMethod = 'Page.loadEventFired'
]
