local chatBubbleNode = include("chatBubbleNode")
local chatNodeFactory = include("chatNodeFactory")
local chatFunctions = include("chatFunctions")
local chatTest = class("chatTest", function(target)
	local isCreateUI = false
	if isCreateUI then
		local view = include("baseView")
		return view.new(cc.size(0, 0), false)
	else
		if target == nil then
			return SoraDCreateBasePanel("commonTestView")
		end
		if type(target) == "string" then
			return SoraDCreateBasePanel(target)
		end
		return target
	end
end)
function chatTest:ctor()
	self:createUI()
	self.Top_Size_Tile_Image_bg = SoraDGetChildByName(self, "Top_Size_Tile_Image_bg")
	self.Top_Size_Tile_Image_bg:setFillType(0)
	self.Top_Node = SoraDGetChildByName(self, "Top_Node")
	self.commonFramTitle_title = SoraDGetExtendChildFromCCSByName(self, "CCS_commonFramTitle_title")
	self.Top_Size_Tile_Image_bg:loadTexture("frame_chat_12.png", ccui.TextureResType.plistType)
	self:init()
end
function chatTest:createUI()
	local CCSUICreator = include("CCSUICreator")
end
function chatTest:init(data)
	self:testPageTurn3D()
end
function chatTest:testPageTurn3DAnimation()
	local sp = display.newSprite("#bg_activity_03.png")
	local nodeGrid = cc.NodeGrid:create()
	sp:setAnchorPoint(cc.p(0, 0))
	sp:setPosition(cc.p(0, 0))
	nodeGrid:addChild(sp)
	sp:setScale(0.5)
	self:addChild(nodeGrid, 35, "bg_activity")
	nodeGrid:setPosition(cc.p(320, 480))
	local posSP = cc.p(sp:getPosition())
	local posLB = sp:convertToWorldSpace(posSP)
	local posRT = sp:convertToWorldSpace(cc.p(posSP.x + sp:getContentSize().width, posSP.y + sp:getContentSize().height))
	nodeGrid:setGridRect(cc.rect(posLB.x, posLB.y, posRT.x - posLB.x, posRT.y - posLB.y + 200))
	local labelName = ccui.Text:create()
	labelName:setFontSize(18)
	labelName:setColor(cc.c3b(255, 255, 255))
	labelName:setString(i18n("common_text_2731"))
	labelName:setTextHorizontalAlignment(cc.TEXT_ALIGNMENT_CENTER)
	labelName:setTextVerticalAlignment(cc.VERTICAL_TEXT_ALIGNMENT_CENTER)
	labelName:setAnchorPoint(SoraDFAP(0.5, 0.5))
	labelName:setPosition(cc.p(0, 150))
	labelName:addTo(nodeGrid)
	local actionPageTurn3D = cc.PageTurn3D:create(6, cc.size(10, 10))
	nodeGrid:runAction(actionPageTurn3D)
	local drawNode = cc.DrawNode:create()
	drawNode:setName("debugNode")
	drawNode:addTo(self, 2)
	drawNode:setPosition(cc.p(0, 0))
	self._debugNode = drawNode
	self._debugNode:clear()
	local lb = posLB
	local lt = cc.p(posLB.x, posRT.y)
	local rt = cc.p(posRT.x, posRT.y)
	local rb = cc.p(posRT.x, posLB.y)
	_UPVALUE4_ = posRT.x
	posRT.x[1] = lb
	posRT.x[2] = lt
	posRT.x[3] = rt
	local posRT.x[4], tbPoints = rb, posRT.x
	_UPVALUE4_ = rt
	rt[1] = lb
	rt[2] = lt
	rt[3] = rt
	rt[4] = rb
	self._debugNode:drawPoly(rt, 4, true, cc.c4f(1, 1, 0, 1))
end
function chatTest:testPageTurn3D()
	local sp = display.newSprite("#bg_activity_03.png")
	local nodeGrid = cc.NodeGrid:create()
	sp:setAnchorPoint(cc.p(0, 0))
	sp:setPosition(cc.p(0, 0))
	nodeGrid:addChild(sp)
	sp:setScale(0.5)
	self:addChild(nodeGrid, 35, "bg_activity")
	nodeGrid:setPosition(cc.p(320, 480))
	local posSP = cc.p(sp:getPosition())
	local posLB = sp:convertToWorldSpace(posSP)
	local posRT = sp:convertToWorldSpace(cc.p(posSP.x + sp:getContentSize().width, posSP.y + sp:getContentSize().height))
	nodeGrid:setGridRect(cc.rect(posLB.x, posLB.y, posRT.x - posLB.x, posRT.y - posLB.y + 200))
	nodeGrid:setAnchorPoint(cc.p(0, 0))
	local labelName = ccui.Text:create()
	labelName:setFontSize(18)
	labelName:setColor(cc.c3b(255, 255, 255))
	labelName:setString(i18n("common_text_2731"))
	labelName:setTextHorizontalAlignment(cc.TEXT_ALIGNMENT_CENTER)
	labelName:setTextVerticalAlignment(cc.VERTICAL_TEXT_ALIGNMENT_CENTER)
	labelName:setAnchorPoint(SoraDFAP(0.5, 0.5))
	labelName:setPosition(cc.p(0, 150))
	labelName:addTo(nodeGrid)
	labelName:setPositionZ(1)
	_UPVALUE2_ = labelName
	labelName[1] = cca.rotateTo(0.5833333333333334, 36.5)
	labelName[2] = cca.rotateTo(0.08333333333333333, 0)
	labelName[3] = cca.delay(1.3333333333333333)
	labelName[4] = cca.delay(1.3333333333333333)
	labelName[5] = cca.delay(1.3333333333333333)
	labelName[6] = cca.delay(1.3333333333333333)
	labelName[7] = cca.delay(1.3333333333333333)
	labelName[8] = cca.delay(1.3333333333333333)
	labelName[9] = cca.delay(1.3333333333333333)
	labelName[10] = cca.delay(1.3333333333333333)
	labelName[11] = cca.delay(1.3333333333333333)
	labelName[12] = cca.delay(1.3333333333333333)
	labelName[13] = cca.delay(1.3333333333333333)
	labelName[14] = cca.delay(1.3333333333333333)
	labelName[15] = cca.delay(1.3333333333333333)
	local seq2 = cca.seq(labelName)
	labelName:runAction(cc.RepeatForever:create(seq2))
	nodeGrid:setPageTurn3D(cc.size(10, 10))
	nodeGrid:updatePageTurn3D(0.1)
	self.nodeGrid = nodeGrid
	nodeGrid:setPageTurn3DParam(0.5, 0.5)
	nodeGrid:getGrid():setCullFaceType(gl.BACK)
	local drawNode = cc.DrawNode:create()
	drawNode:setName("debugNode")
	drawNode:addTo(self, 2)
	drawNode:setPosition(cc.p(0, 0))
	self._debugNode = drawNode
	self._debugNode:clear()
	local lb = posLB
	local lt = cc.p(posLB.x, posRT.y)
	local rt = cc.p(posRT.x, posRT.y)
	local rb = cc.p(posRT.x, posLB.y)
	_UPVALUE4_ = posRT.x
	posRT.x[1] = lb
	posRT.x[2] = lt
	posRT.x[3] = rt
	local posRT.x[4], tbPoints = rb, posRT.x
	_UPVALUE4_ = rt
	rt[1] = lb
	rt[2] = lt
	rt[3] = rt
	rt[4] = rb
	self._debugNode:drawPoly(rt, 4, true, cc.c4f(1, 1, 0, 1))
	local layout = ccui.Layout:create()
	layout:setBackGroundColorType(ccui.LayoutBackGroundColorType.solid)
	layout:setBackGroundColor(cc.c3b(0, 128, 128))
	layout:setContentSize(cc.size(640, 480))
	layout:setPosition(cc.p(0, 0))
	layout:setTouchEnabled(true)
	layout:addTouchEventListener(handler(self, self.onLayoutItem))
	self.dtPage = 0
	local sliderX = cc.CSLoader:createNode(getCCSPath("cityBuildSliderChange"))
	local commonSlider = include("commonSlider")
	_ENV, sliderX = commonSlider.new(sliderX), commonSlider.new(sliderX)
	commonSlider.new(sliderX).maxValue = 255
	commonSlider.new(sliderX).minValue = 1
	commonSlider.new(sliderX).curValue = 1
	local commonSlider.new(sliderX).openEditBox, sliderData = true, commonSlider.new(sliderX)
	sliderX:initData(sliderData)
	sliderX:addTo(self, 35)
	sliderX:setPosition(cc.p(50, 150))
	sliderX:setLocalZOrder(35)
	sliderX:setSliderCallBack(function(valuechange)
		self.dtPage = (valuechange - 1) / 254
		self.nodeGrid:updatePageTurn3D(self.dtPage)
		if self.nodeGrid2 then
			self.nodeGrid2:updatePageTurn3D(self.dtPage)
		end
	end)
	self:testPageTurn3DBack()
end
function chatTest:testPageTurn3DBack()
	local sp = display.newSprite("#bg_activity_06.png")
	local nodeGrid = cc.NodeGrid:create()
	sp:setAnchorPoint(cc.p(0, 0))
	sp:setPosition(cc.p(0, 0))
	nodeGrid:addChild(sp)
	sp:setScale(0.5)
	self:addChild(nodeGrid, 35, "bg_activity")
	nodeGrid:setPosition(cc.p(320, 480))
	local posSP = cc.p(sp:getPosition())
	local posLB = sp:convertToWorldSpace(posSP)
	local posRT = sp:convertToWorldSpace(cc.p(posSP.x + sp:getContentSize().width, posSP.y + sp:getContentSize().height))
	nodeGrid:setGridRect(cc.rect(posLB.x, posLB.y, posRT.x - posLB.x, posRT.y - posLB.y + 200))
	nodeGrid:setAnchorPoint(cc.p(0, 0))
	nodeGrid:setPageTurn3D(cc.size(10, 10))
	nodeGrid:updatePageTurn3D(0.1)
	nodeGrid:setPageTurn3DParam(0.5, 0.5)
	nodeGrid:getGrid():setCullFaceType(gl.FRONT)
	self.nodeGrid2 = nodeGrid
end
function chatTest:onLayoutItem(target, event)
	if event == ccui.TouchEventType.ended then
	elseif event == ccui.TouchEventType.moved then
		local touchBeganPoint = target:getTouchBeganPosition()
		local touchmovePoint = target:getTouchMovePosition()
		local distance = math.abs(touchmovePoint.x - touchBeganPoint.x)
		local dt = distance / 270
		if touchmovePoint.x - touchBeganPoint.x < 0 then
			dt = -dt
		end
		self.dtPage = self.dtPage + dt
		self.dtPage = math.max(0, math.min(1, self.dtPage))
		print("self.dtPage = ", self.dtPage)
		self.nodeGrid:updatePageTurn3D(self.dtPage)
	elseif event == ccui.TouchEventType.canceled then
	elseif event == ccui.TouchEventType.began and not self.dtPage then
		self.dtPage = 0
	end
end
function chatTest:createBubble(data)
	local bubbleNode = chatBubbleNode.new()
	bubbleNode:init(data)
	return bubbleNode
end
function chatTest:createTextBubble(data)
	local chatTextNode = include("chatTextNode")
	local textNode = chatTextNode.new()
	textNode:init(data)
	return textNode
end
function chatTest:createEmoticonNode(data)
	local emoticonNode = include("chatEmoticonNode").new()
	emoticonNode:init(data)
	return emoticonNode
end
function chatTest:createAudioNode(data)
	local audioNode = include("chatAudioNode").new()
	audioNode:init(data)
	return audioNode
end
function chatTest:createRedPacketNode(data)
	local redPacketNode = include("chatRedPacketNode").new()
	redPacketNode:init(data)
	return redPacketNode
end
function chatTest:createHeadNode(data)
	local headNode = include("chatHeadNode").new()
	headNode:init(data)
	return headNode
end
function chatTest:createNameNode(data)
	local nameNode = include("chatNameNode").new()
	nameNode:init(data)
	return nameNode
end
function chatTest:createDateNode(data)
	local dateNode = include("chatDateNode").new()
	dateNode:init(data)
	return dateNode
end
function chatTest:createSystipNode(data)
	local sysTipNode = include("chatSysTipNode").new()
	sysTipNode:init(data)
	return sysTipNode
end
function chatTest:createScroll()
	self.scrollView = ccui.ScrollView:create()
	self.scrollView:setContentSize(cc.size(640, 800))
	self.scrollView:setAnchorPoint(0.5, 0)
	self.scrollView:setBounceEnabled(true)
	self.scrollView:setDirection(1)
	self.scrollView:setPosition(cc.p(320, 20))
	self.scrollView:setListenAllScrollingEnabled(true)
	self.scrollView:addTo(self, 1)
end
function chatTest:testAllBubbles()
	local isDebug = true
	local isRA = true
	self:createScroll()
	local chatSkinRead = include("chatSkinRead")
	self.tbBubbleNodes, _ENV = "chatSkinRead", "chatSkinRead"
	local minContentW = 25
	local maxContentW = 300
	local minContentH = 20
	local maxContentH = 100
	local minBottomW = 100
	local maxBottomW = 250
	local minBottomH = 20
	local maxBottomH = 30
	local direction = gChatDirection.right
	local totalH = 0
	for k, v in ipairs(chatSkinRead.bubble_cfg) do
		local contentSize = cc.size(math.random(minContentW, maxContentW), math.random(minContentH, maxContentH))
		local bottomSize = cc.size(math.random(minBottomW, maxBottomW), math.random(minBottomH, maxBottomH))
		local testHasBottom = math.random(1, 100)
		local testhasBottomTip = math.random(1, 100)
		print("testHasBottom = ", testHasBottom)
		_ENV = print
		print.bubbleId = k
		print.direction = direction
		print.contentSize = contentSize
		print.isRA = isRA
		local print.isDebug, data = isDebug, print
		if 50 < testHasBottom then
			dump(bottomSize, "-----bottomSize", 10)
			data.bottomSize = bottomSize
			if 50 < testhasBottomTip then
				data.bottomTipSize = cc.size(50, bottomSize.height)
				data.bottomSepw = 10
			end
		end
		direction = math.fmod(direction + 1, 2)
		local bubbleNode = self:createBubble(data)
		bubbleNode:addTo(self.scrollView)
		table.insert(self.tbBubbleNodes, bubbleNode)
		totalH = totalH + bubbleNode.height
	end
	local scrollSize = self.scrollView:getContentSize()
	totalH = totalH + 10
	totalH = math.max(totalH, scrollSize.height)
	self.scrollView:setInnerContainerSize(cc.size(scrollSize.width, totalH))
	local accuY = 10
	for i, v in ipairs(self.tbBubbleNodes) do
		if v.data.direction == gChatDirection.left then
			v:setPositionX(100)
		else
			v:setPositionX(scrollSize.width - v.width - 100)
		end
		accuY = accuY + v.height
		v:setPositionY(totalH - accuY)
	end
end
function chatTest:initArrTexts()
	if self.tbArrTexts then
		return
	end
	_ENV = nil
	_ENV, _ENV, (nil).num = nil, nil, 2
	;(nil).color = "#ff0000"
	;(nil).u = "true"
	_ENV, (nil).num, (nil).i = nil, nil, "true"
	;(nil).__default, (nil).color = nil, "#ffffff"
	local str1 = i18n_html("item_des_600103", nil, nil)
	_ENV = nil
	;(nil).color = "#00ff00"
	local str2 = "激活VIP特权" .. SoraDWrapHtmlTagByStyle("100", nil) .. "天。"
	_ENV = nil
	_ENV, _ENV, (nil).build = nil, nil, "x:50 y:20"
	;(nil).u = "true"
	;(nil).c = "true"
	;(nil).color = "#00ee00"
	;(nil).name = "建造1"
	;(nil).build, (nil).custom = nil, "建造坐标1"
	local str3 = i18n_html("common_text_2138", nil, nil)
	_ENV = nil
	_ENV, _ENV, (nil).num = nil, nil, 500
	;(nil).color = "#ffeebb"
	;(nil).u = "true"
	_ENV, (nil).num, (nil).i = nil, nil, "true"
	;(nil).__default, (nil).color = nil, "#ffffff"
	local str4 = i18n_html("item_des_300401", nil, nil)
	_ENV = nil
	_ENV, _ENV, (nil).num = nil, nil, 500
	;(nil).color = "#ffeebb"
	;(nil).u = "true"
	_ENV, (nil).num, (nil).i = nil, nil, "true"
	;(nil).__default, (nil).color = nil, "#ffffff"
	local str5 = i18n_html("item_des_300401", nil, nil)
	_ENV = nil
	;(nil).param = "#emoj_seal_1.png"
	;(nil).name = "图片2"
	;(nil).width = 26
	;(nil).height = 42
	;(nil).custom = "Sprite"
	;(nil).offsety = 20
	str5 = str5 .. "مبنى الحرب" .. SoraDWrapReplaceTag(nil)
	_ENV = nil
	;(nil).u = "true"
	;(nil).c = "true"
	;(nil).color = "#80ee80"
	;(nil).name = "坐标1"
	;(nil).custom = "custom click2"
	_ENV = "منجم الحديد"
	;("منجم الحديد").u = "true"
	;("منجم الحديد").c = "true"
	;("منجم الحديد").color = "#00eeee"
	;("منجم الحديد").name = "坐标2"
	;("منجم الحديد").custom = "custom click3"
	_ENV, str5 = str5, str5 .. "abcdefg" .. SoraDWrapHtmlTagByStyle("مبنى الحرب", nil) .. SoraDWrapHtmlTagByStyle("1234567890" .. "منجم الحديد", "منجم الحديد")
	str5.file = "nongmin_%02d.png"
	str5.astart = 1
	local str5.aend, animationData = 8, str5
	local animationParam = json.encode(animationData)
	print("animationParam = ", animationParam)
	local urlJsonStr = string.urlencode(animationParam)
	print("urlJsonStr = ", animationParam)
	_ENV = animationParam
	animationParam.param = urlJsonStr
	animationParam.name = "动画"
	animationParam.width = 42
	animationParam.height = 40
	animationParam.custom = "Animation"
	animationParam.offsety = 20
	animationParam.scale = 1.0
	animationParam.offsetcy = 15
	local str6 = "使用Lua可以扩展更多内容，比如动画" .. SoraDWrapReplaceTag(animationParam)
	_ENV = nil
	;(nil).color = "#858e52"
	_UPVALUE18_, str6 = str6, str6 .. SoraDWrapHtmlTagByStyle("(支持点击）赶紧试试吧!", nil)
	self.tbArrTexts, str6[1] = str6, "this is test, hello 😄.hahaaha"
	self.tbArrTexts, str6[2] = str6, "今日我们要收复我们失去的领土，无论是生是死，这的一切都将千古流传，为了我们的人民而战"
	self.tbArrTexts, str6[3] = str6, "可招募"
	self.tbArrTexts, str6[4] = str6, "Marching Tents increase the number of regular soldiers trained at one time and the speed of their training. (Infantry, Archers, Cavalry, Chariots)."
	self.tbArrTexts, str6[5] = str6, "The First-aid Tent is where wounded soldiers are treated. Upgrade it to add more space."
	self.tbArrTexts, str6[6] = str6, "Castle"
	self.tbArrTexts, str6[7] = str6, "Wall"
	self.tbArrTexts, str6[8] = str6, "Arrow Tower"
	self.tbArrTexts, str6[9] = str6, "مصنع العربات الحربية هو مكان تصنيع أسلحة الهجوم"
	self.tbArrTexts, str6[10] = str6, "حصن الحرب هو مكان بناء أجهزة الدفاع"
	self.tbArrTexts, str6[11] = str6, "ساحة التدريب هي مكان تجمع الجنود"
	self.tbArrTexts, str6[12] = str6, "مبنى الحرب هو مكان لحشد حلفائك، يمكنكم تشكيل فريق قوي للهجوم على العدو."
	self.tbArrTexts, str6[13] = str6, "المزرعة هي مكان لإنتاج القمح وتخزينه"
	self.tbArrTexts, str6[14] = str6, str1
	self.tbArrTexts, str6[15] = str6, str2
	self.tbArrTexts, str6[16] = str6, str3
	self.tbArrTexts, str6[17] = str6, str4
	self.tbArrTexts, str6[18] = str6, str5
	self.tbArrTexts, str6[19] = str6, str6
	self.tbArrTexts, str6[20] = str6, "这是最后的测试咯"
end
function chatTest:getTextNodeData(data)
	local isDebug = false
	local isRA = true
	local bubbleId = data.bubbleId
	if data.isRA ~= nil then
		isRA = data.isRA
	end
	if data.isDebug ~= nil then
		isDebug = data.isDebug
	end
	local direction = gChatDirection.right
	if data.direction then
		direction = data.direction
	end
	local textAlign = isRA and cc.TEXT_ALIGNMENT_RIGHT or cc.TEXT_ALIGNMENT_LEFT
	local textIndex = bubbleId
	if textIndex > #self.tbArrTexts then
		textIndex = math.random(1, #self.tbArrTexts)
	end
	_ENV = math.random(1, #self.tbArrTexts)
	math.random(1, #self.tbArrTexts).bubbleId = bubbleId
	math.random(1, #self.tbArrTexts).isHtml = true
	math.random(1, #self.tbArrTexts).direction = direction
	math.random(1, #self.tbArrTexts).text = self.tbArrTexts[textIndex]
	math.random(1, #self.tbArrTexts).textAlign = textAlign
	math.random(1, #self.tbArrTexts).isRA = isRA
	local math.random(1, #self.tbArrTexts).isDebug, data = isDebug, math.random(1, #self.tbArrTexts)
	local testHasBottom = math.random(1, 100)
	local testhasBottomTip = math.random(1, 100)
	data.bottomText = "14:28 2018-10-20"
	data.bottomTextTip = "点击查看"
	return data
end
function chatTest:testAllTextNodes()
	local isDebug = false
	local isRA = true
	local textAlign = isRA and cc.TEXT_ALIGNMENT_RIGHT or cc.TEXT_ALIGNMENT_LEFT
	self:initArrTexts()
	local tbArrTexts = self.tbArrTexts
	self:createScroll()
	local chatSkinRead = include("chatSkinRead")
	self.tbBubbleNodes, _ENV = "chatSkinRead", "chatSkinRead"
	local direction = gChatDirection.right
	local totalH = 0
	for k, v in ipairs(chatSkinRead.bubble_cfg) do
		local textIndex = k
		if textIndex > #tbArrTexts then
			textIndex = math.random(1, #tbArrTexts)
		end
		_ENV = #tbArrTexts
		;(#tbArrTexts).bubbleId = k
		;(#tbArrTexts).isRA = isRA
		;(#tbArrTexts).isDebug = isDebug
		;(#tbArrTexts).direction = direction
		local data = self:getTextNodeData(#tbArrTexts)
		direction = math.fmod(direction + 1, 2)
		local bubbleNode = self:createTextBubble(data)
		bubbleNode:addTo(self.scrollView)
		table.insert(self.tbBubbleNodes, bubbleNode)
		totalH = totalH + bubbleNode.height
	end
	local scrollSize = self.scrollView:getContentSize()
	totalH = totalH + 10
	totalH = math.max(totalH, scrollSize.height)
	self.scrollView:setInnerContainerSize(cc.size(scrollSize.width, totalH + 10))
	local accuY = 10
	for i, v in ipairs(self.tbBubbleNodes) do
		if v.data.direction == gChatDirection.left then
			v:setPositionX(100)
		else
			v:setPositionX(scrollSize.width - v.width - 100)
		end
		accuY = accuY + v.height
		v:setPositionY(totalH - accuY)
	end
end
function chatTest:getOneEmotionData(data)
	local isDebug = false
	local isRA = true
	local bubbleId = data.bubbleId
	if data.isRA ~= nil then
		isRA = data.isRA
	end
	if data.isDebug ~= nil then
		isDebug = data.isDebug
	end
	local direction = gChatDirection.right
	if data.direction then
		direction = data.direction
	end
	local _ENV, textAlign = nil, isRA and cc.TEXT_ALIGNMENT_RIGHT or cc.TEXT_ALIGNMENT_LEFT
	;(nil).bubbleId = bubbleId
	;(nil).direction = direction
	;(nil).width = 118
	;(nil).height = 118
	;(nil).packetId = "chat_face"
	;(nil).emoticonId = "chat_face_1"
	;(nil).textAlign = textAlign
	;(nil).isRA = isRA
	local (nil).isDebug, data = isDebug, nil
	data.bottomText = "14:28 2018-10-20"
	return data
end
function chatTest:testAllChatNodes()
	local isDebug = false
	local isRA = true
	local textAlign = isRA and cc.TEXT_ALIGNMENT_RIGHT or cc.TEXT_ALIGNMENT_LEFT
	self:initArrTexts()
	local tbArrTexts = self.tbArrTexts
	self:createScroll()
	local chatSkinRead = include("chatSkinRead")
	self.tbBubbleNodes, _ENV = "chatSkinRead", "chatSkinRead"
	local direction = gChatDirection.right
	local totalH = 0
	for k, v in ipairs(chatSkinRead.bubble_cfg) do
		_ENV = nil
		;(nil).bubbleId = k
		;(nil).isRA = isRA
		;(nil).isDebug = isDebug
		;(nil).direction = direction
		local data = self:getOneEmotionData(nil)
		direction = math.fmod(direction + 1, 2)
		local bubbleNode = self:createEmoticonNode(data)
		bubbleNode:addTo(self.scrollView)
		table.insert(self.tbBubbleNodes, bubbleNode)
		totalH = totalH + bubbleNode.height
	end
	local scrollSize = self.scrollView:getContentSize()
	totalH = totalH + 10
	totalH = math.max(totalH, scrollSize.height)
	self.scrollView:setInnerContainerSize(cc.size(scrollSize.width, totalH + 10))
	local accuY = 10
	for i, v in ipairs(self.tbBubbleNodes) do
		if v.data.direction == gChatDirection.left then
			v:setPositionX(100)
		else
			v:setPositionX(scrollSize.width - v.width - 100)
		end
		accuY = accuY + v.height
		v:setPositionY(totalH - accuY)
	end
end
function chatTest:getOneAudioData(data)
	local isDebug = false
	local isRA = data.isRA
	if isRA == nil then
		isRA = true
	end
	local bubbleId = data.bubbleId
	if data.isDebug ~= nil then
		isDebug = data.isDebug
	end
	local direction = gChatDirection.right
	if data.direction then
		direction = data.direction
	end
	local _ENV, textAlign = nil, isRA and cc.TEXT_ALIGNMENT_RIGHT or cc.TEXT_ALIGNMENT_LEFT
	;(nil).bubbleId = bubbleId
	;(nil).direction = direction
	;(nil).audioId = "xx"
	;(nil).audioLen = math.random(1, 60)
	;(nil).textAlign = textAlign
	;(nil).isRA = isRA
	local (nil).isDebug, data = isDebug, nil
	data.bottomText = "14:28 2018-10-20"
	return data
end
function chatTest:getOneRedPacketData(data)
	local isDebug = false
	local isRA = data.isRA
	if isRA == nil then
		isRA = true
	end
	local bubbleId = data.bubbleId
	if data.isDebug ~= nil then
		isDebug = data.isDebug
	end
	local direction = gChatDirection.right
	if data.direction then
		direction = data.direction
	end
	local textIndex = bubbleId
	if textIndex > #self.tbArrTexts then
		textIndex = math.random(1, #self.tbArrTexts)
	end
	local _ENV, textAlign = 1, isRA and cc.TEXT_ALIGNMENT_RIGHT or cc.TEXT_ALIGNMENT_LEFT
	;(1).bubbleId = bubbleId
	;(1).isHtml = true
	;(1).direction = direction
	;(1).text = self.tbArrTexts[textIndex]
	;(1).textAlign = textAlign
	;(1).isRA = isRA
	local (1).isDebug, data = isDebug, 1
	data.bottomText = "14:28 2018-10-20"
	data.bottomTextTip = "点击查看"
	return data
end
function chatTest:testAudioNodes()
	local isDebug = true
	local isRA = true
	local textAlign = isRA and cc.TEXT_ALIGNMENT_RIGHT or cc.TEXT_ALIGNMENT_LEFT
	self:initArrTexts()
	local tbArrTexts = self.tbArrTexts
	self:createScroll()
	local chatSkinRead = include("chatSkinRead")
	self.tbBubbleNodes, _ENV = "chatSkinRead", "chatSkinRead"
	local direction = gChatDirection.right
	local totalH = 0
	for k, v in ipairs(chatSkinRead.bubble_cfg) do
		_ENV = nil
		;(nil).bubbleId = k
		;(nil).isRA = isRA
		;(nil).isDebug = isDebug
		;(nil).direction = direction
		local data = self:getOneAudioData(nil)
		direction = math.fmod(direction + 1, 2)
		local bubbleNode = self:createAudioNode(data)
		bubbleNode:addTo(self.scrollView)
		table.insert(self.tbBubbleNodes, bubbleNode)
		totalH = totalH + bubbleNode.height
	end
	local scrollSize = self.scrollView:getContentSize()
	totalH = totalH + 10
	totalH = math.max(totalH, scrollSize.height)
	self.scrollView:setInnerContainerSize(cc.size(scrollSize.width, totalH + 10))
	local accuY = 10
	for i, v in ipairs(self.tbBubbleNodes) do
		if v.data.direction == gChatDirection.left then
			v:setPositionX(100)
		else
			v:setPositionX(scrollSize.width - v.width - 100)
		end
		accuY = accuY + v.height
		v:setPositionY(totalH - accuY)
	end
end
function chatTest:testAllRedPacketNodes()
	local isDebug = false
	local isRA = true
	local textAlign = isRA and cc.TEXT_ALIGNMENT_RIGHT or cc.TEXT_ALIGNMENT_LEFT
	self:initArrTexts()
	local tbArrTexts = self.tbArrTexts
	self:createScroll()
	local chatSkinRead = include("chatSkinRead")
	self.tbBubbleNodes, _ENV = "chatSkinRead", "chatSkinRead"
	local direction = gChatDirection.right
	local totalH = 0
	for k, v in ipairs(chatSkinRead.bubble_cfg) do
		_ENV = nil
		;(nil).bubbleId = k
		;(nil).isRA = isRA
		;(nil).isDebug = isDebug
		;(nil).direction = direction
		local data = self:getOneRedPacketData(nil)
		direction = math.fmod(direction + 1, 2)
		local bubbleNode = self:createRedPacketNode(data)
		bubbleNode:addTo(self.scrollView)
		table.insert(self.tbBubbleNodes, bubbleNode)
		totalH = totalH + bubbleNode.height
	end
	local scrollSize = self.scrollView:getContentSize()
	totalH = totalH + 10
	totalH = math.max(totalH, scrollSize.height)
	self.scrollView:setInnerContainerSize(cc.size(scrollSize.width, totalH + 10))
	local accuY = 10
	for i, v in ipairs(self.tbBubbleNodes) do
		if v.data.direction == gChatDirection.left then
			v:setPositionX(100)
		else
			v:setPositionX(scrollSize.width - v.width - 100)
		end
		accuY = accuY + v.height
		v:setPositionY(totalH - accuY)
	end
end
function chatTest:testHeadNodes()
	local isDebug = true
	_ENV = nil
	;(nil).headWearId = 1
	;(nil).avatarFrameId = 1
	;(nil).imageId = 1402
	;(nil).avatar = ""
	;(nil).imgPlayer = "head_m_003.png"
	;(nil).chatType = 0
	;(nil).alv = 3
	local (nil).isDebug, onedata = isDebug, nil
	self:createScroll()
	local chatSkinRead = include("chatSkinRead")
	self.tbBubbleNodes, _ENV = "chatSkinRead", "chatSkinRead"
	local totalH = 0
	local keys = table.keys(chatSkinRead.avatarframe_cfg)
	table.sort(keys, function(a, b)
		return a < b
	end)
	local direction = gChatDirection.right
	for k, v in ipairs(keys) do
		local data = clone(onedata)
		data.avatarFrameId = k
		data.direction = direction
		direction = math.fmod(direction + 1, 2)
		local hasHeadWear = math.random(1, 100)
		print("hasHeadWear = ", hasHeadWear)
		if 50 < hasHeadWear then
			data.headWearId = math.random(1, 3)
		else
			data.headWearId = nil
		end
		data.alv = math.random(1, 5)
		local bubbleNode = self:createHeadNode(data)
		bubbleNode:addTo(self.scrollView)
		table.insert(self.tbBubbleNodes, bubbleNode)
		totalH = totalH + bubbleNode.height
	end
	_UPVALUE1_ = (for generator)
	ipairs(keys)[1] = clone(onedata)
	ipairs(keys)[2] = clone(onedata)
	ipairs(keys)[3] = clone(onedata)
	ipairs(keys)[4] = clone(onedata)
	ipairs(keys)[5] = clone(onedata)
	ipairs(keys)[6] = clone(onedata)
	ipairs(keys)[7] = clone(onedata)
	ipairs(keys)[8] = clone(onedata)
	ipairs(keys)[9] = clone(onedata)
	ipairs(keys)[10] = clone(onedata)
	local ipairs(keys)[11], otherData = clone(onedata)
	otherData[1].flag = 3
	otherData[2].avatarFrameId = nil
	for k, v in ipairs(otherData) do
		local bubbleNode = self:createHeadNode(v)
		bubbleNode:addTo(self.scrollView)
		table.insert(self.tbBubbleNodes, bubbleNode)
		totalH = totalH + bubbleNode.height
	end
	local scrollSize = self.scrollView:getContentSize()
	totalH = totalH + 10
	totalH = math.max(totalH, scrollSize.height)
	self.scrollView:setInnerContainerSize(cc.size(scrollSize.width, totalH))
	local accuY = 10
	for i, v in ipairs(self.tbBubbleNodes) do
		if v.data.direction == gChatDirection.left then
			v:setPositionX(100)
		else
			v:setPositionX(scrollSize.width - v.width - 100)
		end
		accuY = accuY + v.height
		v:setPositionY(totalH - accuY)
	end
end
function chatTest:testNameNodes()
	local isDebug = true
	local isRA = false
	_ENV = nil
	;(nil).name = "(abc)龙腾1024"
	;(nil).kid = 3
	;(nil).isRA = isRA
	local (nil).isDebug, onedata = isDebug, nil
	self:createScroll()
	local chatSkinRead = include("chatSkinRead")
	self.tbBubbleNodes, _ENV = "chatSkinRead", "chatSkinRead"
	local totalH = 0
	local keys = table.keys(chatSkinRead.avatarframe_cfg)
	table.sort(keys, function(a, b)
		return a < b
	end)
	local direction = gChatDirection.right
	for k, v in ipairs(keys) do
		local data = clone(onedata)
		data.direction = direction
		direction = math.fmod(direction + 1, 2)
		data.isRA = isRA
		local hasVip = math.random(1, 100)
		print("hasVip = ", hasVip)
		if 50 < hasVip then
			data.isVip = true
			data.vipLv = math.random(1, 25)
		else
			data.isVip = nil
		end
		local isGM = math.random(1, 100)
		if 50 < isGM then
			data.isGM = true
		else
			data.isGM = false
		end
		data.alv = math.random(1, 5)
		local bubbleNode = self:createNameNode(data)
		bubbleNode:addTo(self.scrollView)
		table.insert(self.tbBubbleNodes, bubbleNode)
		totalH = totalH + bubbleNode.height
	end
	local scrollSize = self.scrollView:getContentSize()
	totalH = totalH + 10
	totalH = math.max(totalH, scrollSize.height)
	self.scrollView:setInnerContainerSize(cc.size(scrollSize.width, totalH))
	local accuY = 10
	for i, v in ipairs(self.tbBubbleNodes) do
		if v.data.direction == gChatDirection.left then
			v:setPositionX(100)
		else
			v:setPositionX(scrollSize.width - v.width - 100)
		end
		accuY = accuY + v.height
		v:setPositionY(totalH - accuY)
	end
end
function chatTest:testDateAndSysTip()
	local isDebug = true
	_ENV = nil
	;(nil).date = "2018-10-24 17:49"
	local (nil).isDebug, dateData = isDebug, nil
	local dateNode = self:createDateNode(dateData)
	dateNode:addTo(self, 2)
	dateNode:setAnchorPoint(cc.p(0.5, 0))
	dateNode:setPosition(cc.p(320, 400))
	_ENV = dateNode.setPosition
	dateNode.setPosition.isRA = false
	dateNode.setPosition.isDebug = isDebug
	local dateNode.setPosition.content, sysData = "这里是各种操作提示这里是各种操作提示这里是各种操作提示这里是各种操作提示这里是各种操作提示", dateNode.setPosition
	local sysTipNode = self:createSystipNode(sysData)
	sysTipNode:addTo(self, 2)
	sysTipNode:setAnchorPoint(cc.p(0.5, 0))
	sysTipNode:setPosition(cc.p(320, 500))
end
function chatTest:getGroupNodeData(customData)
	local nodeType = customData.nodeType
	local _ENV, data
	if nodeType == gChatNodeType.group_text or nodeType == gChatNodeType.group_sys_text then
		data = self:getTextNodeData(customData)
	elseif nodeType == gChatNodeType.group_emoticon then
		data = self:getOneEmotionData(customData)
	elseif nodeType == gChatNodeType.group_audio then
		data = self:getOneAudioData(customData)
	elseif nodeType == gChatNodeType.group_red_packet then
		data = self:getOneRedPacketData(customData)
	elseif nodeType == gChatNodeType.date then
		_ENV = gChatNodeType.date
		gChatNodeType.date.date = "2018-10-24 17:49"
		data, gChatNodeType.date.isDebug = gChatNodeType.date, customData.isDebug
	elseif nodeType == gChatNodeType.systip then
		_ENV = gChatNodeType.systip
		gChatNodeType.systip.isRA = data.isRA
		gChatNodeType.systip.isDebug = customData.isDebug
		data, gChatNodeType.systip.content = gChatNodeType.systip, "这里是各种操作提示这里是各种操作提示这里是各种操作提示这里是各种操作提示这里是各种操作提示"
	else
		print("类型错误-------", nodeType)
	end
	data.name = "(abc)龙腾201810251024"
	data.kid = 3
	data.nodeType = nodeType
	return data
end
function chatTest:testGroupNodes()
	local isDebug = false
	local isRA = false
	_ENV = nil
	;(nil).name = "(abc)龙腾1024"
	;(nil).kid = 3
	;(nil).isRA = isRA
	local (nil).isDebug, onedata = isDebug, nil
	self:initArrTexts()
	self:createScroll()
	local chatSkinRead = include("chatSkinRead")
	self.tbBubbleNodes, _ENV = "chatSkinRead", "chatSkinRead"
	local totalH = 0
	local keys = table.keys(chatSkinRead.avatarframe_cfg)
	table.sort(keys, function(a, b)
		return a < b
	end)
	local direction = gChatDirection.right
	_UPVALUE7_ = keys
	keys[1] = gChatNodeType.date
	keys[2] = gChatNodeType.systip
	keys[3] = gChatNodeType.group_text
	keys[4] = gChatNodeType.group_sys_text
	keys[5] = gChatNodeType.group_emoticon
	keys[6] = gChatNodeType.group_audio
	local keys[7], tbTypes = gChatNodeType.group_red_packet, keys
	for k, v in ipairs(keys) do
		local nodeTypeIndex = math.random(1, #tbTypes)
		local nodeType = tbTypes[nodeTypeIndex]
		_ENV = nil
		;(nil).nodeType = nodeType
		;(nil).bubbleId = k
		;(nil).isRA = isRA
		;(nil).isDebug = isDebug
		;(nil).direction = direction
		local data = self:getGroupNodeData(nil)
		data.direction = direction
		direction = math.fmod(direction + 1, 2)
		data.isRA = isRA
		local hasVip = math.random(1, 100)
		print("hasVip = ", hasVip)
		if 50 < hasVip then
			data.isVip = true
			data.vipLv = math.random(1, 25)
		else
			data.isVip = nil
		end
		local isGM = math.random(1, 100)
		if 50 < isGM then
			data.isGM = true
		else
			data.isGM = false
		end
		local hasHeadWear = math.random(1, 100)
		if 50 < hasHeadWear then
			data.headWearId = math.random(1, 3)
		else
			data.headWearId = nil
		end
		local hasAvatarFrameId = math.random(1, 100)
		if 50 < hasAvatarFrameId then
			local keys = table.keys(chatSkinRead.avatarframe_cfg)
			table.sort(keys, function(a, b)
				return a < b
			end)
			local index = math.random(1, #keys)
			data.avatarFrameId = keys[index]
		end
		data.alv = math.random(1, 5)
		local bubbleNode = chatNodeFactory.createNode(nodeType)
		bubbleNode:init(data)
		bubbleNode:addTo(self.scrollView)
		table.insert(self.tbBubbleNodes, bubbleNode)
		totalH = totalH + bubbleNode.height
	end
	local scrollSize = self.scrollView:getContentSize()
	totalH = totalH + 10
	totalH = math.max(totalH, scrollSize.height)
	self.scrollView:setInnerContainerSize(cc.size(scrollSize.width, totalH))
	local accuY = 10
	for i, v in ipairs(self.tbBubbleNodes) do
		if v.data.direction == gChatDirection.left then
			v:setPositionX(40)
		else
			v:setPositionX(scrollSize.width - v.width - 40)
		end
		accuY = accuY + v.height
		v:setPositionY(totalH - accuY)
	end
	local isDebug = true
	_UPVALUE5_ = ipairs(self.tbBubbleNodes)
	ipairs(self.tbBubbleNodes)[1] = gChatNodeStatus.normal
	ipairs(self.tbBubbleNodes)[2] = gChatNodeStatus.loading
	ipairs(self.tbBubbleNodes)[3] = gChatNodeStatus.warning
	ipairs(self.tbBubbleNodes)[4] = gChatNodeStatus.translating
	local ipairs(self.tbBubbleNodes)[5], tbStatus = gChatNodeStatus.unread, ipairs(self.tbBubbleNodes)
	for i, v in ipairs(tbStatus) do
		local node = include("chatStatusNode").new()
		_ENV = cc.size(scrollSize.width, totalH)
		cc.size(scrollSize.width, totalH).nodeStatus = v
		cc.size(scrollSize.width, totalH).isDebug = isDebug
		node:init(cc.size(scrollSize.width, totalH))
		node:addTo(self, 10)
		node:setPositionX(40 + (i - 1) * 110)
		node:setPositionY(display.height - 160)
	end
end
function chatTest:testAllGroupBubbles()
	local isDebug = false
	local isRA = false
	local direction = gChatDirection.left
	self:initArrTexts()
	self:createScroll()
	local chatSkinRead = include("chatSkinRead")
	self.tbBubbleNodes, _ENV = "chatSkinRead", "chatSkinRead"
	local totalH = 0
	local keys = table.keys(chatSkinRead.avatarframe_cfg)
	table.sort(keys, function(a, b)
		return a < b
	end)
	chatFunctions = table.sort
	local table.sort[1], bubbleKeys = 15, table.sort
	dump(bubbleKeys, "bubbleKeys")
	for _, bubbleId in ipairs(bubbleKeys) do
		local nodeType = gChatNodeType.group_text
		_ENV = nil
		;(nil).nodeType = nodeType
		;(nil).bubbleId = bubbleId
		;(nil).isRA = isRA
		;(nil).isDebug = isDebug
		;(nil).direction = direction
		local data = self:getGroupNodeData(nil)
		data.text = "Marching"
		data.direction = direction
		data.isRA = isRA
		local hasVip = math.random(1, 100)
		print("hasVip = ", hasVip)
		if 50 < hasVip then
			data.isVip = true
			data.vipLv = math.random(1, 25)
		else
			data.isVip = nil
		end
		local isGM = math.random(1, 100)
		if 50 < isGM then
			data.isGM = true
		else
			data.isGM = false
		end
		local hasHeadWear = math.random(1, 100)
		if 50 < hasHeadWear then
			data.headWearId = math.random(1, 3)
		else
			data.headWearId = nil
		end
		local hasAvatarFrameId = math.random(1, 100)
		if 50 < hasAvatarFrameId then
			local keys = table.keys(chatSkinRead.avatarframe_cfg)
			table.sort(keys, function(a, b)
				return a < b
			end)
			local index = math.random(1, #keys)
			data.avatarFrameId = keys[index]
		end
		_ENV, data.alv = math.random(1, 5), math.random(1, 5)
		math.random(1, 5).checkRes = false
		local math.random(1, 5).data, bubbleParam = data, math.random(1, 5)
		data.oriBubbleId = data.bubbleId
		data.bubbleId = chatFunctions.getShowBubbleId(bubbleParam)
		data.showBubbleId = data.bubbleId
		local bubbleNode = chatNodeFactory.createNode(nodeType)
		data.contentSize = cc.size(83, 23)
		bubbleNode:init(data)
		bubbleNode:addTo(self.scrollView)
		table.insert(self.tbBubbleNodes, bubbleNode)
		totalH = totalH + bubbleNode.height
		data.itemNode = bubbleNode
		dump(data, "data")
	end
	local scrollSize = self.scrollView:getContentSize()
	totalH = totalH + 10
	totalH = math.max(totalH, scrollSize.height)
	self.scrollView:setInnerContainerSize(cc.size(scrollSize.width, totalH))
	local accuY = 10
	for i, v in ipairs(self.tbBubbleNodes) do
		if v.data.direction == gChatDirection.left then
			v:setPositionX(40)
		else
			v:setPositionX(scrollSize.width - v.width - 40)
		end
		accuY = accuY + v.height
		v:setPositionY(totalH - accuY)
	end
end
function chatTest:testParser()
	local chatDataParser = include("chatDataParser")
	_ENV, _ENV = nil, "chatDataParser"
	;(nil).trtype = gTextAttrType.soldierid
	;("chatDataParser").army, (nil).trid = nil, 403
	local content = "chatDataParser"
	local textParser = include("textParser")
	local valueMap = textParser.parseValues(content)
	local ret = i18n("common_text_848", valueMap)
	print("chatTest:testParser() ret = ", ret)
	_ENV, _ENV = "chatTest:testParser() ret = ", print
	;("chatTest:testParser() ret = ").trtype = gTextAttrType.plain
	_ENV, print.minPoint, ("chatTest:testParser() ret = ").trvalue = "chatTest:testParser() ret = ", "chatTest:testParser() ret = ", 1
	;("chatTest:testParser() ret = ").trtype = gTextAttrType.plain
	_ENV, print.winPoint, ("chatTest:testParser() ret = ").trvalue = "chatTest:testParser() ret = ", "chatTest:testParser() ret = ", 5
	local serverValues = print
	;("chatTest:testParser() ret = ").textType = gChatTextType.text_auto
	;("chatTest:testParser() ret = ").kingdomMsgType = gSystemNoticeKingdomMsgTypeDef.remains_war_score
	local ("chatTest:testParser() ret = ").values, chatContent = serverValues, "chatTest:testParser() ret = "
	ret = chatDataParser.parseChatContentText(chatContent)
	print("ret = ", ret)
end
return chatTest
