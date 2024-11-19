Class {
	#name : #ChromeMessageQueueNotes,
	#superclass : #Object,
	#traits : 'TGtUniqueInstance',
	#classTraits : 'TGtUniqueInstance classTrait',
	#instVars : [
		'notes'
	],
	#category : #'Gt4ChromeDevTools-Notes'
}

{ #category : #'instance creation' }
ChromeMessageQueueNotes class >> import: aString [

	^ STON fromString: aString
]

{ #category : #'instance creation' }
ChromeMessageQueueNotes class >> importDefault: aString [

	uniqueInstance := self import: aString.
	^ uniqueInstance
]

{ #category : #'instance creation' }
ChromeMessageQueueNotes class >> importDefaultFromFileReference: aFileReference [

	uniqueInstance := self importFromFileReference: aFileReference.
	^ uniqueInstance
]

{ #category : #'instance creation' }
ChromeMessageQueueNotes class >> importFromFileReference: aFileReference [

	^ aFileReference
		  readStreamEncoded: #utf8
		  do: [ :aStream | STON fromStream: aStream ]
]

{ #category : #adding }
ChromeMessageQueueNotes >> addNote: aNote [

	self notes add: aNote
]

{ #category : #adding }
ChromeMessageQueueNotes >> addTitle: aTitle node: aNode messages: aCollection screenshot: aBase64 [

	| aNote |
	aNote := ChromeMessageQueueNote new
		         title: aTitle;
		         node: aNode;
		         messages: aCollection;
		         screenshot: aBase64.

	self addNote: aNote
]

{ #category : #'gt - extensions' }
ChromeMessageQueueNotes >> gtNotesFor: aView [

	<gtView>
	notes ifNil: [ ^ aView empty ].

	^ aView columnedList
		  title: 'Notes';
		  priority: 1;
		  items: [ self notes copy ];
		  column: 'Title' text: #title weight: 3;
		  column: 'Number of Messages'
		  text: [ :aNote | aNote messages size ];
		  column: 'Actions' stencil: [ :anItem | 
			  BrButton new
				  fitContent;
				  beTinySize;
				  aptitude: BrGlamorousButtonWithIconAptitude;
				  icon: BrGlamorousIcons minimize;
				  label: 'Remove note';
				  action: [ :theButton | 
					  self notes remove: anItem ifAbsent: [ "ignore" ].
					  theButton phlow firstParentWithViewContent phlow update ] ]
		  width: 60;
		  actionUpdateButton;
		  actionButtonIcon: BrGlamorousIcons trash
		  tooltip: 'Clear Message Queue'
		  action: [ :aButton :aTab | 
			  self notes removeAll.
			  aTab viewContentElement phlow update ]
]

{ #category : #accessing }
ChromeMessageQueueNotes >> gtStoreScript: aView [

	<gtView>
	self notes ifNil: [ ^ aView empty ].

	^ aView textEditor
		  title: 'Export';
		  priority: 10;
		  aptitude: [ BrGlamorousCodeEditorAptitude ];
		  text: [ STON toStringPretty: self ];
		  actionButtonIcon: BrGlamorousIcons save
		  label: 'Save'
		  tooltip: 'Save to disk'
		  action: [ :aButton :aTab | 
			  | aFileName |
			  aFileName := './google-chrome-notes.ston.txt' asFileReference.
			  aFileName ensureDelete.
			  aFileName
				  writeStreamEncoded: #utf8
				  do: [ :aStream | STON put: self onStreamPretty: aStream ] ];
		  actionUpdateButton 
]

{ #category : #accessing }
ChromeMessageQueueNotes >> initialize [
	super initialize.
	
	notes := OrderedCollection new.
]

{ #category : #accessing }
ChromeMessageQueueNotes >> notes [

	^ notes
]
