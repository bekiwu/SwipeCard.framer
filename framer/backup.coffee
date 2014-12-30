# This imports all the layers for "SwipeCards" into swipecardsLayers
swipecardsLayers = Framer.Importer.load "imported/SwipeCards"

me = swipecardsLayers.me
heart = swipecardsLayers.heart
scrollTip = swipecardsLayers.scrollTip

heart.visible = false

photo1 = swipecardsLayers.photo1
photo2 = swipecardsLayers.photo2
photo3 = swipecardsLayers.photo3
photo4 = swipecardsLayers.photo4

photoEmpty = swipecardsLayers.photoEmpty
photoEmpty2 = swipecardsLayers.photoEmpty2


photos =
	[photo1
	photo2
	photo3
	photo4]

# 初始化参数
DEVICE_WIDTH = 750
DEVICE_HEIGHT = 1334

PHOTO_WIDTH = 700
PHOTO_HEIGHT = 520

CARD_NUM = photos.length
CARD_WIDTH = photo1.width
CARD_HEIGHT = photo1.height

CARD_CURRENT_SCALE = 1
CARD_NEXT_SCALE = 0.9
CARD_OFFSET_SCALE = 0.95
# CARD_DRAG_SCALE = 0.75
# CARD_TOUCHSTART_SCALE = 0.9

CARD_MARGIN = 30
CARD_MARGIN_MAX_OFFSET = 10

CARD_OFFSET_Y = -40

EXPANDED_CARD_Y = 700
INIT_CARD_Y = 1000

CONTAINER_DRAG_MAX = 200
CONTAINER_DRAG_REBOUNCE = 50

ENDING_HEIGHT = 900


# 变量
cards = []

likes = 
	[49
	43
	28
	16]
	
dates = 
	['2014.1.6'
	'2014.4.21'
	'2014.6.17'
	'2014.9.23']
	

container = new Layer
	width: DEVICE_WIDTH
	height: CARD_NUM * CARD_HEIGHT + (CARD_NUM - 2) * CARD_MARGIN + INIT_CARD_Y + ENDING_HEIGHT
	backgroundColor: 'transparent'
	
me.superLayer = container

endingSection = new Layer
	y: CARD_NUM * CARD_HEIGHT + (CARD_NUM - 2) * CARD_MARGIN + INIT_CARD_Y
	height: ENDING_HEIGHT
	width: DEVICE_WIDTH
	backgroundColor: 'transparent'
	opacity: 0
	
endingSection.html = '在过去的一年里<br>你总共获得了1024个赞'
endingSection.style = 
	fontSize: '58px'
	textAlign: 'center'
	lineHeight: '80px'
	paddingTop: '180px'
	
endingSection.center()
endingSection.placeBehind(container)
	
btnEnter = new Layer
	y: 300
	width: 382
	height: 90
	borderRadius: 8
	superLayer: endingSection
	backgroundColor: 'transparent'

btnEnter.html = '进入微信6.1'
btnEnter.centerX()

btnEnter.style = 
	fontSize: '32px'
	lineHeight: '92px'
	border: '1px solid white'
	textAlign: 'center'
	

# 重置动画按钮 Demo only	
# btnRestart = new Layer
# 	width: 300
# 	height: 80
# Utils.labelLayer(btnRestart, 'Restart')
# btnRestart.style.fontSize = '36px'
# btnRestart.center()
# btnRestart.on Events.Click, ->
# 	initApp()

animationFadeOut = new Animation
	layer: scrollTip
	properties: {opacity: 0}
	curve: 'ease-in-out'
	time: 2
	
animationFadeIn = animationFadeOut.reverse()

animationFadeOut.on Events.AnimationEnd, ->
	animationFadeIn.start()
	
animationFadeIn.on Events.AnimationEnd, ->
	animationFadeOut.start()
	
animationFadeOut.start()
	

# 初始化卡片
initCards = ->
	for i in [(CARD_NUM - 1)..0]
		card = new Layer
			y: INIT_CARD_Y
			backgroundColor: 'transparent'
			width: CARD_WIDTH
			height: CARD_HEIGHT
			borderRadius: 10
			superLayer: container
						
		card.centerX()
		
		photos[i].x = 0
		photos[i].y = 0
		photos[i].superLayer = card
		
		photos[i].name = 'photo'
		
# 		if i > 0
# 			photos[i].opacity = 0
# 			
# 			if i == 2
# 				card.addSubLayer(photoEmpty2)
# 				photoEmpty2.x = 0
# 				photoEmpty2.y = 0
# 				
# 				photoEmpty2.name = 'photoEmpty'
# 			
# 			if i == 1
# 				card.addSubLayer(photoEmpty)
# 				photoEmpty.x = 0
# 				photoEmpty.y = 0
# 				
# 				photoEmpty.name = 'photoEmpty'
		
		mask = new Layer
			superLayer: card
			width: PHOTO_WIDTH
			height: PHOTO_HEIGHT
			backgroundColor: 'rgba(0,0,0,.2)'
			opacity: 0
		
		mask.center()
		mask.name = 'mask'
		
		like = new Layer
			backgroundColor: 'transparent'
			superLayer: card
			width: 160
			height: 100
			opacity: 0
			
		like.html = likes[i]
		like.style =
			fontSize: '76px'
			lineHeight: '76px'
			textAlign: 'right'
		
		like.center()		
		like.name = 'like'
		
		heartIcon = heart.copy()
		heartIcon.superLayer = like
		heartIcon.x = 0
		heartIcon.y = -74
		heartIcon.visible = true
		
		date = new Layer
			width: 160
			height: 32
			superLayer: like
			backgroundColor: 'transparent'
		
		date.html = dates[i]
		date.style =
			fontSize: '28px'
			lineHeight: '28px'
			textAlign: 'center'
		
		
		cards[i] = card

initStackPos = (cards) ->
	cardFirst  = cards[0]
	
# 	cardFirst.draggable.enabled = true
# 	cardFirst.draggable.speedX = 0
	
	for i in [(CARD_NUM - 1)..0]
		cards[i].subLayersByName('mask')[0].opacity = 0
		
		if i > 0
			photos[i].opacity = 0

			if i == 2
				cards[i].addSubLayer(photoEmpty2)
				photoEmpty2.x = 0
				photoEmpty2.y = 0
				photoEmpty2.opacity = 1
				
				photoEmpty2.name = 'photoEmpty'
			
			if i == 1
				cards[i].addSubLayer(photoEmpty)
				photoEmpty.x = 0
				photoEmpty.y = 0
				photoEmpty.opacity = 1
				
				photoEmpty.name = 'photoEmpty'
			
# 			cards[i].subLayersByName('photoEmpty')[0].animate
# 				properties:
# 					opacity: 1
				
				
		cards[i].initScale = CARD_NEXT_SCALE * Math.pow(CARD_OFFSET_SCALE,i - 1)
		cards[i].initY = INIT_CARD_Y + Math.floor(i * CARD_OFFSET_Y * Math.pow(0.9, i))
		
		cards[i].scale = cards[i].initScale	
		cards[i].y = cards[i].initY
		
# 		if cards[i].y >= INIT_CARD_Y
# 		cards[i].subLayersByName('photo')[0].animate
# 			properties:
# 				opacity: 1
					
# 			if i == 1 or i ==2
# 				cards[i].subLayersByName('photoEmpty')[0].animate
# 					properties:
# 						opacity: 1


# 初始化卡片序列
initStack = (cards) ->
	cardFirst  = cards[0]
	
	cardFirst.draggable.enabled = true
	cardFirst.draggable.speedX = 0
	
	initStackPos(cards)
		
# 	第一张卡片拖动
	cardFirst.on Events.DragMove, ->
		
		dragDist = INIT_CARD_Y - cardFirst.y + EXPANDED_CARD_Y
		
# 		移动除第一张卡片外的其它卡片
		for i in [0..cards.length - 1]
		
			if i > 0
				cards[i].cardY =
					Utils.modulate(dragDist, 
					[EXPANDED_CARD_Y, INIT_CARD_Y],
					[cards[i].initY, EXPANDED_CARD_Y + (CARD_MARGIN + CARD_HEIGHT) * i], true)				
				if cards[i].y >= INIT_CARD_Y
					cards[i].subLayersByName('photo')[0].animate
						properties:
							opacity: 1
							
					if i == 1 or i ==2
						cards[i].subLayersByName('photoEmpty')[0].animate
							properties:
								opacity: 0
			else
				cards[i].cardY = cards[i].y
				
			
			cards[i].cardScale =
				Utils.modulate(dragDist,
				[EXPANDED_CARD_Y, INIT_CARD_Y],
				[cards[i].initScale, CARD_CURRENT_SCALE], false)
			
			cards[i].animate
				properties:
					y: cards[i].cardY
					scale: cards[i].cardScale
				curve: 'spring(400,20,10)'
	
# 	第一张卡片结束拖动
	cardFirst.on Events.DragEnd, ->
		
		if this.y <= EXPANDED_CARD_Y

			for i in [0..cards.length - 1]
				cards[i].animate
					properties:
						y: EXPANDED_CARD_Y + (CARD_MARGIN + CARD_HEIGHT) * i
						scale: CARD_CURRENT_SCALE
					curve: 'spring(200,20,10)'
			
			cardFirst.ignoreEvents = true
			
			container.draggable.enabled = true
			container.draggable.speedX = 0
			container.draggable.speedY = 1.2
			
			scrollTip.animateStop()
			scrollTip.opacity = 0
			
			container.animate
				properties:
					y: -650
				curve: 'spring(200,25,10)'	
			
# 			容器拖动时
			container.on Events.DragMove, ->
				dragV = Math.abs(container.draggable.calculateVelocity().y)
				scale = Utils.modulate(dragV, [0, 10], [1,  0.9], true)
# 				margin = Utils.modulate(dragV, [0, 10], [0,  CARD_MARGIN_MAX_OFFSET], false)
				
# 				container.animate
# 					properties:
# 						scaleY: scale
# 					curve: 'spring(400,20,10)'
					
				meOpacity = Utils.modulate(container.y, [0, -me.y], [1, 0])
				
				me.animate
					properties:
						opacity: meOpacity
					curve: 'spring(200,20,10)'

				isFixed = false
				
				for i in [0..(CARD_NUM - 1)]
					cards[i].widgetOpacity = 
						Utils.modulate(container.y, 
						[-CARD_HEIGHT * i,  -CARD_HEIGHT * i/2 - EXPANDED_CARD_Y ], 
						[0, 1], true)
						
					if isFixed
						cards[i].widgetOpacity = 1
					
					if cards[i].widgetOpacity >= 1
						isFixed = true
						
					cards[i].subLayersByName('like')[0].animate
						properties:
							opacity: cards[i].widgetOpacity
						curve: 'spring(200,20,10)'
						
					cards[i].subLayersByName('mask')[0].animate
						properties:
							opacity: cards[i].widgetOpacity
						curve: 'spring(200,20,10)'
						
# 				print container.y	
						
				if container.y <= -1850
# 					endingSection.animateStop()
					endingSection.animate
						properties:
							opacity: 1
						curve: 'ease-in-out'
						time: 0.4
						
				if container.y > -1800
# 					endingSection.animateStop()
					endingSection.animate
						properties:
							opacity: 0
						curve: 'ease-in-out'
						time: 0.2
				
			
# 			拖动容器时
			container.on Events.DragEnd, ->
				container.scaleY = 1
				
				topMax = CONTAINER_DRAG_REBOUNCE
				bottomMax = -container.height + DEVICE_HEIGHT - CONTAINER_DRAG_REBOUNCE
				
# 				print container.y

				if container.y <= -1850
# 					endingSection.animateStop()
					endingSection.animate
						properties:
							opacity: 1
						curve: 'ease-in-out'
						time: 0.4
						
				if container.y > -1800
# 					endingSection.animateStop()
					endingSection.animate
						properties:
							opacity: 0
						curve: 'ease-in-out'
						time: 0.2
				
				if container.y >= 220
					initStack(cards)
# 					for i in [1..(CARD_NUM - 1)]
# # 						if cards[i].y >= INIT_CARD_Y
# 						cards[i].subLayersByName('photo')[0].animate
# 							properties:
# 								opacity: 0
				
				if container.y > topMax
					container.animate
						properties:
							y: topMax
						curve: 'spring(200,25,10)'
						
				else if container.y < bottomMax
					container.animate
						properties:
							y: bottomMax
						curve: 'spring(200,25,10)'

		else
			
# 			卡片复位
# 			initStack(cards)
			for i in [(CARD_NUM - 1)..0]
				cards[i].animate
					properties:
						scale: cards[i].initScale
						y: cards[i].initY
					curve: 'spring(200,20,10)'

# 初始化程序
initApp = ->				
	initCards()
	initStack(cards)
	
initApp()



