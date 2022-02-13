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

{ #category : #adding }
ChromeMessageQueueNotes >> addNote: aNote [

	self notes add: aNote
]

{ #category : #adding }
ChromeMessageQueueNotes >> addTitle: aTitle node: aNode messages: aCollection [

	| aNote |
	aNote := ChromeMessageQueueNote new
		         title: aTitle;
		         node: aNode;
		         messages: aCollection.

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
		  text: [ :aNote | aNote messages size ]
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
