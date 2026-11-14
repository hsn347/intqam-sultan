local htmlRichTestView = class("htmlRichTestView", function(target)
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
function htmlRichTestView:ctor()
	self:createUI()
	self.Top_Size_Tile_Image_bg = SoraDGetChildByName(self, "Top_Size_Tile_Image_bg")
	self.Top_Node = SoraDGetChildByName(self, "Top_Node")
	self.commonFramTitle_title = SoraDGetExtendChildFromCCSByName(self, "Top_CCS_commonFramTitle_node")
	self.commonFramTitle_title:setTitle("富文本测试")
	self:init()
end
function htmlRichTestView:createUI()
	local CCSUICreator = include("CCSUICreator")
end
function htmlRichTestView:createHtmlRichText()
	local textChat = HtmlRichText:create("", "", 22)
	textChat:setTextHorizontalAlignment(cc.TEXT_ALIGNMENT_LEFT)
	textChat:setTextVerticalAlignment(cc.VERTICAL_TEXT_ALIGNMENT_TOP)
	textChat:setTextColor(cc.c3b(255, 255, 255))
	textChat:setPosition(cc.p(320, 480))
	textChat:setAnchorPoint(cc.p(0.0, 1))
	textChat:setSwallowTouches(false)
	textChat:setTouchEnabled(true)
	textChat:addTouchEventListener(handler(self, self.onTextEvent))
	textChat:setIsDebugEnable(true)
	textChat:setIsHtml(true)
	return textChat
end
function htmlRichTestView:createCppRichText()
	local textChat = ccui.Text:create("", "", 20)
	textChat:setTextHorizontalAlignment(cc.TEXT_ALIGNMENT_LEFT)
	textChat:setTextVerticalAlignment(cc.VERTICAL_TEXT_ALIGNMENT_TOP)
	textChat:setTextColor(cc.c3b(255, 255, 255))
	textChat:setPosition(cc.p(320, 480))
	textChat:setAnchorPoint(cc.p(0.0, 1))
	textChat:setSwallowTouches(false)
	textChat:setTouchEnabled(true)
	textChat:addTouchEventListener(handler(self, self.onTextEvent))
	textChat:setIsRichTextCpp(true)
	textChat:setIsDebugEnableCpp(true)
	textChat:setIsHtml(true)
	return textChat
end
function htmlRichTestView:createNormalText()
	local textChat = ccui.Text:create("", "", 20)
	textChat:setTextHorizontalAlignment(cc.TEXT_ALIGNMENT_LEFT)
	textChat:setTextVerticalAlignment(cc.VERTICAL_TEXT_ALIGNMENT_TOP)
	textChat:setTextColor(cc.c3b(255, 255, 255))
	textChat:setPosition(cc.p(320, 480))
	textChat:setAnchorPoint(cc.p(0.0, 1))
	return textChat
end
local sizeToStr = function(size)
	return string.format("{w=%d,h=%d}", size.width, size.height)
end
function htmlRichTestView:initTest()
	self:createBtns()
	local chatDataParser = include("chatDataParser")
	_ENV = nil
	local strIcon = chatDataParser.wrapSystemRich_icon(nil, nil)
	_ENV = nil
	;(nil).x = 176
	;(nil).y = 528
	local str = i18n("alliance_chat_notice_10", nil)
	_ENV = nil
	str = chatDataParser.wrapTexCoord(nil, str)
	str = strIcon .. str
	local textChat = self:createHtmlRichText()
	textChat:addTo(self, 2)
	textChat:setIsDebugEnable(true)
	textChat:setPosition(cc.p(50, display.height - 600))
	textChat:setString(str)
	local height = SoraDGetAutoHeightLabel(textChat, 300)
	table.insert(self.arrTexts, textChat)
	do return end
	_ENV = textChat
	local strIcon = chatDataParser.wrapSystemRich_icon(nil, textChat)
	local heroltCtrl = gModuleMgr.sharedMgr("heroltCtrl")
	local heroExInfo = heroltCtrl.getHeroInfo(1700)
	local heroName = i18n(heroExInfo.herName)
	_ENV = cc.p(50, display.height - 600)
	cc.p(50, display.height - 600).color = "#00ee00"
	cc.p(50, display.height - 600).c = true
	cc.p(50, display.height - 600).name = "hero"
	cc.p(50, display.height - 600).custom = "custom click"
	heroName = SoraDWrapHtmlTagByStyle(heroName, cc.p(50, display.height - 600))
	local strHero = i18n("hero_text_103")
	local str = strIcon .. strHero .. heroName
	local textChat = self:createHtmlRichText()
	textChat:addTo(self, 2)
	textChat:setIsDebugEnable(true)
	textChat:setPosition(cc.p(50, display.height - 600))
	textChat:setString(str)
	local height = SoraDGetAutoHeightLabel(textChat, 300)
	table.insert(self.arrTexts, textChat)
end
function htmlRichTestView:testVAlign()
	local chatDataParser = include("chatDataParser")
	_ENV = nil
	local strIcon = chatDataParser.wrapSystemRich_icon(nil, nil)
	_ENV = nil
	;(nil).x = 176
	;(nil).y = 528
	local str = i18n("alliance_chat_notice_10", nil)
	_ENV = nil
	str = chatDataParser.wrapTexCoord(nil, str)
	str = strIcon .. str
	local textChat = self:createHtmlRichText()
	textChat:addTo(self, 2)
	textChat:setIsDebugEnable(true)
	textChat:setAnchorPoint(cc.p(0, 0.5))
	textChat:setPosition(cc.p(50, display.height - 600))
	textChat:setString(str)
	textChat:setContentSize(cc.size(300, 500))
	textChat:setTextVerticalAlignment(cc.VERTICAL_TEXT_ALIGNMENT_CENTER)
	textChat:ignoreContentAdaptWithSize(false)
	table.insert(self.arrTexts, textChat)
	local textChat = self:createHtmlRichText()
	textChat:addTo(self, 2)
	textChat:setIsDebugEnable(true)
	textChat:setAnchorPoint(cc.p(0, 0.5))
	textChat:setPosition(cc.p(50, display.height - 600))
	textChat:setString(str)
	textChat:setContentSize(cc.size(300, 500))
	textChat:setTextVerticalAlignment(cc.VERTICAL_TEXT_ALIGNMENT_TOP)
	textChat:ignoreContentAdaptWithSize(false)
	table.insert(self.arrTexts, textChat)
	local textChat = self:createHtmlRichText()
	textChat:addTo(self, 2)
	textChat:setIsDebugEnable(true)
	textChat:setAnchorPoint(cc.p(0, 0.5))
	textChat:setPosition(cc.p(50, display.height - 600))
	textChat:setString(str)
	textChat:setContentSize(cc.size(300, 500))
	textChat:setTextVerticalAlignment(cc.VERTICAL_TEXT_ALIGNMENT_BOTTOM)
	textChat:ignoreContentAdaptWithSize(false)
	table.insert(self.arrTexts, textChat)
	local defenseLayout = ccui.Layout:create()
	defenseLayout:setBackGroundColorType(ccui.LayoutBackGroundColorType.solid)
	defenseLayout:setBackGroundColor(cc.c3b(128, 128, 128))
	defenseLayout:setContentSize(cc.size(300, 500))
	defenseLayout:setOpacity(80)
	defenseLayout:setAnchorPoint(cc.p(0, 0.5))
	defenseLayout:setPosition(cc.p(50, display.height - 600))
	defenseLayout:addTo(self, 1)
	return
end
function htmlRichTestView:init(data)
	self.arrTexts, _ENV, self.isDebug = nil, nil, false
	_ENV = nil
	_ENV, _ENV, (nil).num = nil, nil, 2
	;(nil).color = "#ff0000"
	;(nil).u = "true"
	_ENV, (nil).num, (nil).i = nil, nil, "true"
	;(nil).__default, (nil).color = nil, "#ffffff"
	local str = i18n_html("item_des_600103", nil, nil)
	local textChat = self:createHtmlRichText()
	textChat:addTo(self, 2)
	textChat:setPosition(cc.p(50, display.height - 200))
	textChat:setString(str)
	table.insert(self.arrTexts, textChat)
	_ENV = cc.p(50, display.height - 200)
	cc.p(50, display.height - 200).color = "#00ff00"
	local str = "激活VIP特权" .. SoraDWrapHtmlTagByStyle("100", cc.p(50, display.height - 200)) .. "天。"
	local textChat = self:createHtmlRichText()
	textChat:addTo(self, 2)
	textChat:setPosition(cc.p(50, display.height - 240))
	textChat:setString(str)
	table.insert(self.arrTexts, textChat)
	_ENV = cc.p(50, display.height - 240)
	cc.p(50, display.height - 240).color = "#00ff00"
	local str = "Activates VIP status for " .. SoraDWrapHtmlTagByStyle("100", cc.p(50, display.height - 240)) .. " day。"
	local textChat = self:createHtmlRichText()
	textChat:addTo(self, 2)
	textChat:setPosition(cc.p(50, display.height - 280))
	textChat:setString(str)
	table.insert(self.arrTexts, textChat)
	_ENV = cc.p(50, display.height - 280)
	cc.p(50, display.height - 280).color = "#00ff00"
	local str = "سيتم تنشيط مزايا vip لمدة  " .. SoraDWrapHtmlTagByStyle("100", cc.p(50, display.height - 280)) .. " أيام."
	local textChat = self:createHtmlRichText()
	textChat:addTo(self, 2)
	textChat:setPosition(cc.p(50, display.height - 320))
	textChat:setString(str)
	_ENV = str
	_ENV, _ENV, str.build = cc.p(50, display.height - 320)
	cc.p(50, display.height - 320).u = "true"
	cc.p(50, display.height - 320).c = "true"
	cc.p(50, display.height - 320).color = "#00ee00"
	cc.p(50, display.height - 320).name = "建造1"
	cc.p(50, display.height - 320).build, cc.p(50, display.height - 320).custom = cc.p(50, display.height - 320)
	local str = i18n_html("common_text_2138", str, cc.p(50, display.height - 320))
	local textChat = self:createHtmlRichText()
	textChat:addTo(self, 2)
	textChat:setPosition(cc.p(50, display.height - 360))
	textChat:setString(str)
	table.insert(self.arrTexts, textChat)
	_ENV = textChat
	_ENV, _ENV, textChat.build = cc.p(50, display.height - 360)
	cc.p(50, display.height - 360).u = "true"
	cc.p(50, display.height - 360).c = "true"
	cc.p(50, display.height - 360).color = "#00ee00"
	cc.p(50, display.height - 360).name = "建造1"
	cc.p(50, display.height - 360).build, cc.p(50, display.height - 360).custom = cc.p(50, display.height - 360)
	local str = i18n_html("common_text_2138", textChat, cc.p(50, display.height - 360))
	local textChat = self:createHtmlRichText()
	textChat:addTo(self, 2)
	textChat:setIsDebugEnable(false)
	textChat:setPosition(cc.p(50, display.height - 400))
	textChat:setString(str)
	table.insert(self.arrTexts, textChat)
	_ENV = textChat
	_ENV, _ENV, textChat.num = cc.p(50, display.height - 400)
	cc.p(50, display.height - 400).color = "#ffeebb"
	cc.p(50, display.height - 400).u = "true"
	_ENV, cc.p(50, display.height - 400).num, cc.p(50, display.height - 400).i = cc.p(50, display.height - 400)
	cc.p(50, display.height - 400).__default, cc.p(50, display.height - 400).color = cc.p(50, display.height - 400)
	local str = i18n_html("item_des_300401", textChat, cc.p(50, display.height - 400))
	_ENV = cc.p(50, display.height - 400)
	cc.p(50, display.height - 400).param = "#banyungong_es_07.png"
	cc.p(50, display.height - 400).name = "图片2"
	cc.p(50, display.height - 400).width = 26
	cc.p(50, display.height - 400).height = 42
	cc.p(50, display.height - 400).custom = "Sprite"
	cc.p(50, display.height - 400).offsety = 20
	cc.p(50, display.height - 400).scale = 1.0
	str = str .. "مبنى الحرب" .. SoraDWrapReplaceTag(cc.p(50, display.height - 400))
	str = str .. "图片周围有较多透明边的，需要设置 scale和 offsetcx以及 offsetcy，不会会被挤压的很小"
	local textChat = self:createHtmlRichText()
	textChat:addTo(self, 2)
	textChat:setIsDebugEnable(false)
	textChat:setPosition(cc.p(50, display.height - 440))
	textChat:setString(str)
	local height = SoraDGetAutoHeightLabel(textChat, 300)
	table.insert(self.arrTexts, textChat)
	_ENV = textChat
	_ENV, _ENV, textChat.num = cc.p(50, display.height - 440)
	cc.p(50, display.height - 440).color = "#ffeebb"
	cc.p(50, display.height - 440).u = "true"
	_ENV, cc.p(50, display.height - 440).num, cc.p(50, display.height - 440).i = cc.p(50, display.height - 440)
	cc.p(50, display.height - 440).__default, cc.p(50, display.height - 440).color = cc.p(50, display.height - 440)
	local str = i18n_html("item_des_300401", textChat, cc.p(50, display.height - 440))
	_ENV = cc.p(50, display.height - 440)
	cc.p(50, display.height - 440).param = "#emoj_seal_1.png"
	cc.p(50, display.height - 440).name = "图片2"
	cc.p(50, display.height - 440).width = 26
	cc.p(50, display.height - 440).height = 42
	cc.p(50, display.height - 440).custom = "Sprite"
	cc.p(50, display.height - 440).offsety = 20
	str = str .. "مبنى الحرب" .. SoraDWrapReplaceTag(cc.p(50, display.height - 440))
	_ENV = cc.p(50, display.height - 440)
	cc.p(50, display.height - 440).u = "true"
	cc.p(50, display.height - 440).c = "true"
	cc.p(50, display.height - 440).color = "#00ee00"
	cc.p(50, display.height - 440).name = "坐标1"
	cc.p(50, display.height - 440).custom = "custom click2"
	_ENV = "منجم الحديد"
	;("منجم الحديد").u = "true"
	;("منجم الحديد").c = "true"
	;("منجم الحديد").color = "#00eeee"
	;("منجم الحديد").name = "坐标2"
	;("منجم الحديد").custom = "custom click3"
	str = str .. "abcdefg" .. SoraDWrapHtmlTagByStyle("مبنى الحرب", cc.p(50, display.height - 440)) .. SoraDWrapHtmlTagByStyle("1234567890" .. "منجم الحديد", "منجم الحديد")
	local textChat = self:createHtmlRichText()
	textChat:addTo(self, 2)
	textChat:setIsDebugEnable(true)
	textChat:setPosition(cc.p(50, display.height - 600))
	textChat:setString(str)
	local height = SoraDGetAutoHeightLabel(textChat, 300)
	table.insert(self.arrTexts, textChat)
	local textChat = self:createCppRichText()
	textChat:addTo(self, 2)
	textChat:setPosition(cc.p(50, display.height - 720))
	local newStr = "CPP version:" .. str
	textChat:setString(newStr)
	local height = SoraDGetAutoHeightLabel(textChat, 300)
	table.insert(self.arrTexts, textChat)
	_ENV = table.insert
	table.insert.file = "nongmin_%02d.png"
	table.insert.astart = 1
	local table.insert.aend, animationData = 8, table.insert
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
	local str = "使用Lua可以扩展更多内容，比如动画" .. SoraDWrapReplaceTag(animationParam)
	_ENV = cc.p(50, display.height - 720)
	cc.p(50, display.height - 720).color = "#55ee00"
	str = str .. SoraDWrapHtmlTagByStyle("(支持点击）赶紧试试吧!", cc.p(50, display.height - 720))
	local textChat = self:createHtmlRichText()
	textChat:addTo(self, 2)
	textChat:setIsDebugEnable(false)
	textChat:setPosition(cc.p(50, display.height - 860))
	textChat:setString(str)
	local height = SoraDGetAutoHeightLabel(textChat, 500)
	table.insert(self.arrTexts, textChat)
	_ENV = cc.p(50, display.height - 860)
	cc.p(50, display.height - 860).num = 500
	local str = "自由的测试:" .. i18n("item_des_300401", cc.p(50, display.height - 860))
	_ENV = cc.p(50, display.height - 860)
	cc.p(50, display.height - 860).param = "#icon_main_powegem.png"
	cc.p(50, display.height - 860).name = "图片2"
	cc.p(50, display.height - 860).width = 20
	cc.p(50, display.height - 860).height = 22
	cc.p(50, display.height - 860).custom = "Sprite"
	cc.p(50, display.height - 860).offsety = 4
	str = str .. SoraDWrapReplaceTag(cc.p(50, display.height - 860))
	_ENV = cc.p(50, display.height - 860)
	cc.p(50, display.height - 860).u = "true"
	cc.p(50, display.height - 860).c = "true"
	cc.p(50, display.height - 860).color = "#00ee00"
	cc.p(50, display.height - 860).name = "链接1"
	cc.p(50, display.height - 860).custom = "custom click2"
	str = str .. SoraDWrapHtmlTagByStyle("x:50,y:20", cc.p(50, display.height - 860))
	_ENV = "منجم الحديد"
	;("منجم الحديد").u = "true"
	;("منجم الحديد").c = "true"
	;("منجم الحديد").color = "#0000ee"
	;("منجم الحديد").name = "连接2"
	;("منجم الحديد").custom = "custom click2"
	str = str .. SoraDWrapHtmlTagByStyle("مبنى الحرب" .. "منجم الحديد", "منجم الحديد")
	local textChat = self:createHtmlRichText()
	textChat:addTo(self, 2)
	textChat:setIsDebugEnable(false)
	textChat:setPosition(cc.p(380, display.height - 200))
	textChat:setString(str)
	local height = SoraDGetAutoHeightLabel(textChat, 250)
	table.insert(self.arrTexts, textChat)
	_ENV = cc.p(380, display.height - 200)
	_ENV, _ENV, cc.p(380, display.height - 200).num = cc.p(380, display.height - 200)
	cc.p(380, display.height - 200).color = "#ffeebb"
	cc.p(380, display.height - 200).u = "true"
	_ENV, cc.p(380, display.height - 200).num, cc.p(380, display.height - 200).i = cc.p(380, display.height - 200)
	cc.p(380, display.height - 200).__default, cc.p(380, display.height - 200).color = cc.p(380, display.height - 200)
	local str = "字符串测量测试:" .. i18n_html("item_des_300401", cc.p(380, display.height - 200))
	str = str .. ""
	str = str .. "x:50,y:20"
	str = str .. "مبنى الحرب" .. "منجم الحديد"
	local textChat = self:createHtmlRichText()
	textChat:addTo(self, 2)
	textChat:setIsDebugEnable(false)
	textChat:setPosition(cc.p(380, display.height - 300))
	local limitW = 250
	local beginOld = SoraDGetSocketTime()
	print("SoraDGetSocketTime = ", beginOld)
	textChat:setString(str)
	local heightOld = SoraDGetAutoHeightLabel(textChat, limitW)
	local endOld = SoraDGetSocketTime()
	print("SoraDGetSocketTime = ", endOld)
	local timeOld = endOld - beginOld
	table.insert(self.arrTexts, textChat)
	local oldSize = textChat:getContentSize()
	dump(oldSize, "字符串初始化测量宽高:")
	local heightNew = 0.0
	local testSize = cc.size(0, 0)
	local timeNew = 0.0
	if cc.Device.getTextureWidthHeightForText then
		local beginNew = SoraDGetSocketTime()
		_ENV = cc.p(380, display.height - 300)
		cc.p(380, display.height - 300).fontName = ""
		cc.p(380, display.height - 300).fontSize = 20
		cc.p(380, display.height - 300).fontAlignmentH = cc.TEXT_ALIGNMENT_LEFT
		cc.p(380, display.height - 300).fontAlignmentV = cc.VERTICAL_TEXT_ALIGNMENT_TOP
		cc.p(380, display.height - 300).fontDimensions = cc.size(limitW, 0)
		cc.p(380, display.height - 300).isHtml = true
		testSize = cc.Device:getTextureWidthHeightForText(str, cc.p(380, display.height - 300))
		local endNew = SoraDGetSocketTime()
		timeNew = endNew - beginNew
		dump(testSize, "纯粹测量的size")
	else
		SoraDShowMsgTip("测量失败!")
	end
	_ENV = timeOld
	timeOld.color = "#ee0000"
	local str = "原版本正常测量大小" .. sizeToStr(oldSize) .. ", 消耗:" .. SoraDWrapHtmlTagByStyle(tostring(timeOld), timeOld) .. "\n"
	_ENV = timeNew
	timeNew.color = "#00ee00"
	str = str .. "新版纯测量大小" .. sizeToStr(testSize) .. ", 消耗:" .. SoraDWrapHtmlTagByStyle(tostring(timeNew), timeNew) .. "\n"
	local textChat = self:createHtmlRichText()
	textChat:addTo(self, 2)
	textChat:setIsDebugEnable(false)
	textChat:setPosition(cc.p(380, display.height - 400))
	textChat:setString(str)
	SoraDGetAutoHeightLabel(textChat, 250)
	table.insert(self.arrTexts, textChat)
	_ENV = cc.p(380, display.height - 400)
	cc.p(380, display.height - 400).num = 500
	local str = "非富文本测量中:" .. i18n("item_des_300401", cc.p(380, display.height - 400))
	str = str .. " "
	str = str .. "x:50,y:20"
	str = str .. "مبنى الحرب" .. "منجم الحديد"
	local textChat = self:createNormalText()
	textChat:addTo(self, 2)
	textChat:setPosition(cc.p(380, display.height - 600))
	local limitW = 250
	local beginOld = SoraDGetSocketTime()
	print("SoraDGetSocketTime = ", beginOld)
	textChat:setString(str)
	local heightOld = SoraDGetAutoHeightLabel(textChat, limitW)
	local endOld = SoraDGetSocketTime()
	print("SoraDGetSocketTime = ", endOld)
	local timeOld = endOld - beginOld
	table.insert(self.arrTexts, textChat)
	local oldSize = textChat:getContentSize()
	dump(oldSize, "字符串初始化测量宽高:")
	local heightNew = 0.0
	local testSize = cc.size(0, 0)
	local timeNew = 0.0
	if cc.Device.getTextureWidthHeightForText then
		local beginNew = SoraDGetSocketTime()
		_ENV = cc.p(380, display.height - 600)
		cc.p(380, display.height - 600).fontName = ""
		cc.p(380, display.height - 600).fontSize = 20
		cc.p(380, display.height - 600).fontAlignmentH = cc.TEXT_ALIGNMENT_LEFT
		cc.p(380, display.height - 600).fontAlignmentV = cc.VERTICAL_TEXT_ALIGNMENT_TOP
		cc.p(380, display.height - 600).fontDimensions = cc.size(limitW, 0)
		testSize = cc.Device:getTextureWidthHeightForText(str, cc.p(380, display.height - 600))
		local endNew = SoraDGetSocketTime()
		timeNew = endNew - beginNew
		dump(testSize, "纯粹测量的size")
	else
		SoraDShowMsgTip("测量失败!")
	end
	_ENV = timeOld
	timeOld.color = "#ee0000"
	local str = "非富文本正常测量大小" .. sizeToStr(oldSize) .. ", 消耗:" .. SoraDWrapHtmlTagByStyle(tostring(timeOld), timeOld) .. "\n"
	_ENV = timeNew
	timeNew.color = "#00ee00"
	str = str .. "非富文本纯测量大小" .. sizeToStr(testSize) .. ", 消耗:" .. SoraDWrapHtmlTagByStyle(tostring(timeNew), timeNew) .. "\n"
	local textChat = self:createHtmlRichText()
	textChat:addTo(self, 2)
	textChat:setIsDebugEnable(false)
	textChat:setPosition(cc.p(380, display.height - 680))
	textChat:setString(str)
	SoraDGetAutoHeightLabel(textChat, 250)
	table.insert(self.arrTexts, textChat)
	local btnToggle = ccui.Button:create()
	btnToggle:loadTextures("btn_green_normal_01.png", "", "", ccui.TextureResType.plistType)
	btnToggle:setButtonType(ccui.ButtonType.TRISTATE)
	btnToggle:setContentSize(cc.size(216, 272))
	self:addChild(btnToggle)
	btnToggle:setPosition(cc.p(140, display.height - 50))
	btnToggle:setLocalZOrder(3)
	self.btnToggle = btnToggle
	self.btnToggle:setTitleFontSize(24)
	self.btnToggle:setTitleText("切换调试")
	self.btnToggle:addTouchEventListener(function(target, event)
		if event == ccui.TouchEventType.ended then
			self.isDebug = not self.isDebug
			for i, v in ipairs(self.arrTexts) do
				if v.setIsDebugEnable then
					v:setIsDebugEnable(self.isDebug)
				elseif v.setIsDebugEnableCpp then
					v:setIsDebugEnableCpp(self.isDebug)
				end
			end
		end
	end)
	local str = "طوال اليوم.(abc)ATS" .. "المفق(abc)ودين إ(abc)لى جرحى (abc)أثناء المعركة(abc)"
	str = "طوال اليوم" .. "abc" .. "(لب)" .. "لبطل"
	local textChat = self:createHtmlRichText()
	textChat:addTo(self, 2)
	textChat:setPosition(cc.p(250, display.height - 80))
	textChat:setLocalZOrder(3)
	textChat:setString(str)
	SoraDGetAutoHeightLabel(textChat, 350)
	local btnToggleA = ccui.Button:create()
	btnToggleA:loadTextures("btn_green_normal_01.png", "", "", ccui.TextureResType.plistType)
	btnToggleA:setButtonType(ccui.ButtonType.TRISTATE)
	btnToggleA:setContentSize(cc.size(216, 272))
	self:addChild(btnToggleA)
	btnToggleA:setPosition(cc.p(500, display.height - 50))
	btnToggleA:setLocalZOrder(3)
	self.btnToggleA = btnToggleA
	self.btnToggleA:setTitleFontSize(24)
	self.btnToggleA:setTitleText("切换左右对齐")
	self.btnToggleA:addTouchEventListener(function(target, event)
		if event == ccui.TouchEventType.ended then
			self.isDebug = not self.isDebug
			for i, v in ipairs(self.arrTexts) do
				if v:getTextHorizontalAlignment() == cc.TEXT_ALIGNMENT_RIGHT then
					v:setTextHorizontalAlignment(cc.TEXT_ALIGNMENT_LEFT)
				elseif v:getTextHorizontalAlignment() == cc.TEXT_ALIGNMENT_LEFT then
					v:setTextHorizontalAlignment(cc.TEXT_ALIGNMENT_RIGHT)
				end
			end
		end
	end)
end
function htmlRichTestView:createBtns()
	local btnToggle = ccui.Button:create()
	btnToggle:loadTextures("btn_green_normal_01.png", "", "", ccui.TextureResType.plistType)
	btnToggle:setButtonType(ccui.ButtonType.TRISTATE)
	btnToggle:setContentSize(cc.size(216, 272))
	self:addChild(btnToggle)
	btnToggle:setPosition(cc.p(140, display.height - 50))
	btnToggle:setLocalZOrder(3)
	self.btnToggle = btnToggle
	self.btnToggle:setTitleFontSize(24)
	self.btnToggle:setTitleText("切换调试")
	self.btnToggle:addTouchEventListener(function(target, event)
		if event == ccui.TouchEventType.ended then
			self.isDebug = not self.isDebug
			for i, v in ipairs(self.arrTexts) do
				if v.setIsDebugEnable then
					v:setIsDebugEnable(self.isDebug)
				elseif v.setIsDebugEnableCpp then
					v:setIsDebugEnableCpp(self.isDebug)
				end
			end
		end
	end)
	local btnToggleA = ccui.Button:create()
	btnToggleA:loadTextures("btn_green_normal_01.png", "", "", ccui.TextureResType.plistType)
	btnToggleA:setButtonType(ccui.ButtonType.TRISTATE)
	btnToggleA:setContentSize(cc.size(216, 272))
	self:addChild(btnToggleA)
	btnToggleA:setPosition(cc.p(500, display.height - 50))
	btnToggleA:setLocalZOrder(3)
	self.btnToggleA = btnToggleA
	self.btnToggleA:setTitleFontSize(24)
	self.btnToggleA:setTitleText("切换左右对齐")
	self.btnToggleA:addTouchEventListener(function(target, event)
		if event == ccui.TouchEventType.ended then
			self.isDebug = not self.isDebug
			for i, v in ipairs(self.arrTexts) do
				if v:getTextHorizontalAlignment() == cc.TEXT_ALIGNMENT_RIGHT then
					v:setTextHorizontalAlignment(cc.TEXT_ALIGNMENT_LEFT)
				elseif v:getTextHorizontalAlignment() == cc.TEXT_ALIGNMENT_LEFT then
					v:setTextHorizontalAlignment(cc.TEXT_ALIGNMENT_RIGHT)
				end
			end
		end
	end)
end
function htmlRichTestView:onMessageListener()
end
function htmlRichTestView:onTextEvent(target, event)
	if event == ccui.TouchEventType.began then
	elseif event == ccui.TouchEventType.ended then
		if self.singleIsMoved then
			self.singleIsMoved = false
			return
		end
		local metaInfo = target:getTouchMetaInfo(target:getTouchEndPosition())
		dump(metaInfo, "metaInfo")
		if metaInfo then
			if metaInfo.metatype == ccui.RichTextMetaType.REPLACE then
				SoraDShowMsgTip("点击了占位符----" .. metaInfo.name)
				SoraDPlaySound()
			else
				SoraDShowMsgTip("点击了超链接---" .. metaInfo.name)
				SoraDPlaySound()
			end
		end
	elseif event == ccui.TouchEventType.moved then
		local touchBeganPoint = target:getTouchBeganPosition()
		local touchmovePoint = target:getTouchMovePosition()
		local distance = cc.pGetDistance(touchBeganPoint, touchmovePoint)
		if tonumber(distance) > TOUCH_MOVED_ERROR_VALUE then
			self.singleIsMoved = true
		end
	elseif event == ccui.TouchEventType.canceled then
		self.singleIsMoved = false
	end
end
return htmlRichTestView
