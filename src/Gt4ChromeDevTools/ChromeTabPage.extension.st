Extension { #name : #ChromeTabPage }

{ #category : #'*Gt4ChromeDevTools' }
ChromeTabPage >> captureScreenshotBase64 [
	"Capture a screenshot of the current page at full resolution"
	| json layout message |

	layout := self getLayoutMetrics.
	message := ChromePageMessageFactory new 
		captureScreenshotX: 0 y: 0 
		width: ((layout at: 'contentSize') at: 'width')
		height: ((layout at: 'contentSize') at: 'height')
		scale: 1.0.
	json := self sendMessage: message.
	^ (json at: 'result') at: 'data'.
]

{ #category : #'*Gt4ChromeDevTools' }
ChromeTabPage >> gtGetMissingChildrenFor: anAction [

	<gtAction>
	self rootNode ifNil: [ ^ anAction noAction ].
	self gtNodesWithMissingChildren ifEmpty: [ ^ anAction noAction ].

	^ anAction button
		  priority: 1;
		  target: (GtPhlowActionTarget forViewSelector: #gtRootNodeFor:);
		  icon: BrGlamorousVectorIcons down;
		  label: 'Missing';
		  tooltip: 'Get missing children';
		  action: [ :aButton :aTab | 
			  aButton withAsyncFutureDo: [ :anElementFuture | 
					  anElementFuture
						  whenPending: [ :theButton | theButton disable ];
						  whennError: [ :theButton :anError | theButton enable ];
						  whenSuccess: [ :theButton :aCollection | 
							  aCollection ifEmpty: [ 
									  theButton
										  disable;
										  visibility: BlVisibility gone ] ] ].
			  aButton asyncFuture future: [ 
				  self getMissingChildren.
				  aTab viewContentElement phlow update.
				  self gtNodesWithMissingChildren ] asAsyncFuture ]
]

{ #category : #'*Gt4ChromeDevTools' }
ChromeTabPage >> gtMessageProcessorsFor: aView [

	<gtView>
	messageProcessors ifNil: [ ^ aView empty ].

	^ aView columnedList
		  title: 'Message processors';
		  priority: 40;
		  items: [ 
			  messageProcessorMutex critical: [ messageProcessors copy ] ];
		  actionUpdateButton;
		  column: 'Type' text: #yourself;
		  column: 'State' text: #gtMessageProcessorsViewStateText weight: 2
]

{ #category : #'*Gt4ChromeDevTools' }
ChromeTabPage >> gtMessageQueueFor: aView [

	<gtView>
	messageQueue ifNil: [ ^ aView empty ].

	^ aView columnedList
		  title: 'Message queue';
		  priority: 39;
		  items: [ messageQueue copy ];
		  actionDropdownButtonIcon: BrGlamorousVectorIcons down
		  label: 'Note'
		  tooltip: 'Extract and remove message events with a note'
		  content: [ :aButton :aTab | 
			  | anEditor |
			  BrVerticalPane new
				  alignCenterLeft;
				  width: 300;
				  vFitContent;
				  padding: (BlInsets all: 10);
				  addChild: (anEditor := BrEditor new
						               aptitude: BrGlamorousRegularEditorAptitude;
						               border:
							               (BlBorder
								                paint:
									                BrGlamorousColors disabledButtonTextColor
								                width: 1);
						               margin: (BlInsets bottom: 10);
						               hMatchParent;
						               vFitContent);
				  addChild: (BrToolbar new
						   fitContent;
						   aptitude: BrGlamorousToolbarAptitude;
						   addItem: (BrButton new
								    aptitude: BrGlamorousButtonWithIconAptitude;
								    icon: BrGlamorousVectorIcons accept;
								    label: 'Make a note';
								    action: [ :anAcceptButton | 
									    | aCopy aNode aScreenshot |
									    aCopy := messageQueue copy.
									    aNode := self getDocument.
									    self getMissingChildren.
									    aScreenshot := self captureScreenshotBase64.

									    ChromeMessageQueueNotes default
										    addTitle: anEditor text asString
										    node: aNode
										    messages: aCopy
										    screenshot: aScreenshot.

									    messageQueue removeAll.
									    aTab viewContentElement phlow update ]);
						   addItem: (BrButton new
								    aptitude: BrGlamorousButtonWithIconAptitude;
								    icon: BrGlamorousVectorIcons inspect;
								    label: 'Inspect notes';
								    action: [ :anInspectButton | 
									    aButton phlow spawnObject:
											    ChromeMessageQueueNotes default ])) ];
		  actionUpdateButton;
		  actionButtonIcon: BrGlamorousIcons trash
		  tooltip: 'Clear Message Queue'
		  action: [ :aButton :aTab | 
			  messageQueue removeAll.
			  aTab viewContentElement phlow update ];
		  column: 'Index' text: [ :anItem :anIndex | anIndex ] width: 40;
		  column: 'Type' text: #yourself
]

{ #category : #'*Gt4ChromeDevTools' }
ChromeTabPage >> gtNodesWithMissingChildren [

	<return: #Array of: #ChromeNode>
	^ self rootNode allSelect: [ :each | 
		  each childNodeCount > each children size ]
]

{ #category : #'*Gt4ChromeDevTools' }
ChromeTabPage >> gtRootNodeFor: aView [

	<gtView>
	^ aView columnedTree
		  title: 'Root node';
		  priority: 1;
		  items: [ self rootNode ifNotNil: #asArray ifNil: [ #(  ) ] ];
		  children: #children;
		  actionUpdateButton;
		  column: 'Name' text: #gtChildrenViewText;
		  expandUpTo: 2
]

{ #category : #'*Gt4ChromeDevTools' }
ChromeTabPage >> pageEventListener [

	<return: #ChromePageEventsProcessor>
	^ messageProcessorMutex critical: [ 
		  messageProcessors
			  detect: [ :each | each class = ChromePageEventsProcessor ]
			  ifFound: [ :aMessageProcessor | aMessageProcessor ]
			  ifNone: [ 
				  self addMessageProcessor:
					  (ChromePageEventsProcessor new page: self) ] ]
]
