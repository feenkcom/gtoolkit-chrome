Class {
	#name : #ChromePageAnnouncement,
	#superclass : #Announcement,
	#instVars : [
		'page',
		'message'
	],
	#category : #'Gt4ChromeDevTools-Announcements'
}

{ #category : #'instance creation' }
ChromePageAnnouncement class >> forMethod: method [

	NonInteractiveTranscript stdout show: method; cr.
	
	self allSubclassesDo: [ :eachClass | 
		(eachClass isForMethod: method) ifTrue: [ ^ eachClass new ] ].

	^ nil
]

{ #category : #testing }
ChromePageAnnouncement class >> isForMethod: aMethod [

	^ false
]

{ #category : #accessing }
ChromePageAnnouncement >> message [

	<return: #Dictionary>
	^ message
]

{ #category : #accessing }
ChromePageAnnouncement >> message: aMessageDictionary [

	message := aMessageDictionary
]

{ #category : #accessing }
ChromePageAnnouncement >> page [

	<return: #ChromePage>
	^ page
]

{ #category : #accessing }
ChromePageAnnouncement >> page: aChromePage [

	page := aChromePage
]
