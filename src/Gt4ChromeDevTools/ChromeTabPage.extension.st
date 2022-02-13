Extension { #name : #ChromeTabPage }

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
		  title: 'Message Processors';
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
		  title: 'Message Queue';
		  priority: 39;
		  items: [ messageQueue copy ];
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
		  title: 'Root Node';
		  priority: 1;
		  items: [ self rootNode ifNotNil: #asArray ifNil: [ #(  ) ] ];
		  children: #children;
		  actionUpdateButton;
		  column: 'Name' text: #gtChildrenViewText;
		  expandUpTo: 2;
		  updateWhen: ChromePageDOMDocumentUpdated
		  in: [ self pageEventListener ] 
]
