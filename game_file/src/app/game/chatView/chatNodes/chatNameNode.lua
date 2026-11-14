local chatNameNode = class("chatNameNode", function(target)
	local target = include("chatBaseNode").new("chatNameNode")
	return target
end)
_ENV = "chatNameNode"
;("chatNameNode").gmSize = cc.size(54, 32)
;("chatNameNode").height = 30
;("chatNameNode").width = 300
;("chatNameNode").fontSize = 20
;("chatNameNode").fontcolor = cc.c3b(25, 23, 26)
local ("chatNameNode").nightcolor, _defaultParam = cc.c3b(255, 255, 255), "chatNameNode"
function chatNameNode:ctor()
	self.singleIsMoved = false
	self.isDebug = gChatDebug
	self.width = _defaultParam.width
	self.height = _defaultParam.height
	self.text = HtmlRichText:create("", "", 20)
	self.text:setTextVerticalAlignment(cc.VERTICAL_TEXT_ALIGNMENT_BOTTOM)
	self.text:setAnchorPoint(cc.p(0, 0.5))
	self.text:setPositionY(_defaultParam.height / 2)
	self.text:addTo(self, 1)
end
function chatNameNode:reset()
	self:hideVip()
	self:hideGM()
	self:hideOfficial()
	self:hideFootballMonsterCamp()
end
function chatNameNode:init(data)
	self.data = data
	self:reset()
	local isVip = data.isVip
	local vipLv = data.vipLv or 0
	local name = data.name
	local align = data.align
	local isGM = data.isGM
	local kid = data.kid
	self.isRA = data.isRA or SoraDFIsRA()
	local theme = data.theme
	theme = theme or gCurrentChatTheme
	if data.isDebug ~= nil then
		self.isDebug = data.isDebug
	end
	local gametop = gModuleMgr.getObject("gametop")
	local currentKid
	if gametop.playertop_ then
		currentKid = gametop.playertop_:getKingdomID()
	end
	if kid ~= nil and (kid ~= currentKid or data.isKohMigrateChatRoom) then
		name = name .. "#" .. kid
	end
	self.nodePaddings, _ENV, self.tbShowNodes, _ENV = name, name, name, name
	if isGM then
		self:showGM()
		table.insert(self.tbShowNodes, self.spriteGM)
		table.insert(self.nodePaddings, 0)
	end
	if isVip and 0 < vipLv then
		self:showVip(vipLv)
		table.insert(self.tbShowNodes, self.spriteVip)
		table.insert(self.nodePaddings, 4)
	end
	self.text:setString(name)
	if theme == gChatTheme.normal then
		self.text:setTextColor(_defaultParam.fontcolor)
	else
		self.text:setTextColor(_defaultParam.nightcolor)
	end
	table.insert(self.tbShowNodes, self.text)
	local officialType = data.officialType
	local officialTitle = data.officialTitle
	if officialType and officialTitle then
		self:showOfficial(officialType, officialTitle)
		table.insert(self.tbShowNodes, self.spriteOfficial)
	end
	local footballMonsterCamp = not data.footballMonsterCamp and data.serverMsg and data.serverMsg.footballMonsterCamp
	if footballMonsterCamp then
		self:showFootballMonsterCamp(footballMonsterCamp)
		if self.spriteFootballMonsterCamp then
			table.insert(self.tbShowNodes, self.spriteFootballMonsterCamp)
		end
	end
	self:alignContent()
	self:initDebugView()
end
function chatNameNode:showOfficial(officialType, officialId)
	local lordOfficialRead = include("lordOfficialRead")
	local officialIcon = lordOfficialRead.getOfficialIcon(officialType, officialId)
	if self.spriteOfficial then
		self.spriteOfficial:setVisible(true)
		self.spriteOfficial:setSpriteFrame(officialIcon)
		local sWidth = self.spriteOfficial:getContentSize().width
		if 0 < sWidth then
			self.spriteOfficial:setScale(40 / sWidth)
		end
		return
	end
	local sprite = display.newSprite("#" .. officialIcon)
	sprite:addTo(self)
	local sWidth = sprite:getContentSize().width
	if 0 < sWidth then
		sprite:setScale(40 / sWidth)
	end
	sprite:setAnchorPoint(cc.p(0.5, 0.5))
	sprite:setPosition(cc.p(0, _defaultParam.height / 2))
	self.spriteOfficial = sprite
end
function chatNameNode:hideOfficial(...)
	if self.spriteOfficial then
		self.spriteOfficial:setVisible(false)
	end
end
function chatNameNode:alignContent()
	if self.isRA then
		self.tbShowNodes = table.reverse(self.tbShowNodes)
		self.nodePaddings = table.reverse(self.nodePaddings)
	end
	self.width = SoraDAlignNodeArrayOnBeginX(0, self.tbShowNodes, false, self.nodePaddings)
	self:setContentSize(self.width, self.height)
end
function chatNameNode:setIsDebug(isDebug)
	self.isDebug = isDebug
end
function chatNameNode:showVipParticle(text_vip, vipLv)
	SoraDGetVIPEffectByLv(text_vip, vipLv)
end
function chatNameNode:showVip(vipLv)
	if not self.spriteVip then
		local cache
		if self.scroll and self.scroll.parentView then
			cache = self.scroll.parentView.tableSpare
		end
		local spriteVip, isNew, needRelease = chatNodeFactory.getNode(gChatNodeType.vip, cache, vipLv)
		self.spriteVip = spriteVip
		self.spriteVip:init(self.data)
		if not SoraDFIsRA() then
			self.spriteVip:setAnchorPoint(SoraDFAP(0, 0.5))
			self.spriteVip:setPosition(cc.p(115, _defaultParam.height / 2))
		else
			self.spriteVip:setAnchorPoint(0, 0.5)
			self.spriteVip:setPosition(cc.p(0, _defaultParam.height / 2))
		end
		self.spriteVip:addTo(self)
		if needRelease then
			self.spriteVip:release()
		end
	else
		self.spriteVip:setVisible(true)
	end
end
function chatNameNode:hideVip()
	if self.spriteVip then
		local cache
		if self.scroll and self.scroll.parentView then
			cache = self.scroll.parentView.tableSpare
		end
		chatNodeFactory.addNode(self.spriteVip, gChatNodeType.vip, cache, self.spriteVip.vipLv)
		self.spriteVip:removeFromParent()
		self.spriteVip = nil
	end
end
function chatNameNode:showGM()
	if self.spriteGM then
		self.spriteGM:setVisible(true)
	else
		self.spriteGM = display.newSprite("#" .. "icon_chat_gm.png")
		self.spriteGM:addTo(self)
		self.spriteGM:setAnchorPoint(SoraDFAP(0, 0.5))
		self.spriteGM:setPosition(cc.p(115, _defaultParam.height / 2))
	end
end
function chatNameNode:hideGM()
	if self.spriteGM then
		self.spriteGM:setVisible(false)
	end
end
function chatNameNode:showFootballMonsterCamp(campType)
	local activity_9001737_Read = include("activity_9001737_Read")
	local campCfg = activity_9001737_Read.getCampCfgByCampType(campType)
	if not campCfg or not campCfg.campIcon then
		return
	end
	local campIcon = campCfg.campIcon
	if self.spriteFootballMonsterCamp then
		self.spriteFootballMonsterCamp:setVisible(true)
		self.spriteFootballMonsterCamp:setSpriteFrame(campIcon)
		local sWidth = self.spriteFootballMonsterCamp:getContentSize().width
		if 0 < sWidth then
			self.spriteFootballMonsterCamp:setScale(40 / sWidth)
		end
		return
	end
	local sprite = display.newSprite("#" .. campIcon)
	sprite:addTo(self)
	local sWidth = sprite:getContentSize().width
	if 0 < sWidth then
		sprite:setScale(40 / sWidth)
	end
	sprite:setAnchorPoint(SoraDFAP(0, 0.5))
	sprite:setPosition(cc.p(0, _defaultParam.height / 2))
	self.spriteFootballMonsterCamp = sprite
end
function chatNameNode:hideFootballMonsterCamp()
	if self.spriteFootballMonsterCamp then
		self.spriteFootballMonsterCamp:setVisible(false)
	end
end
function chatNameNode:initDebugView()
	if not self.isDebug then
		return
	end
	if not self._debugNode then
		local drawNode = cc.DrawNode:create()
		drawNode:setName("debugNode")
		drawNode:addTo(self, 2)
		drawNode:setPosition(cc.p(0, 0))
		self._debugNode = drawNode
	end
	self._debugNode:clear()
	local lb = cc.p(0, 0)
	local lt = cc.p(0, self.height)
	local rt = cc.p(self.width, self.height)
	local rb = cc.p(self.width, 0)
	_UPVALUE4_ = self.width
	self.width[1] = lb
	self.width[2] = lt
	self.width[3] = rt
	local self.width[4], tbPoints = rb, self.width
	_UPVALUE4_ = rt
	rt[1] = lb
	rt[2] = lt
	rt[3] = rt
	rt[4] = rb
	self._debugNode:drawPoly(rt, 4, true, cc.c4f(1, 1, 0, 1))
end
function chatNameNode.measureSize(data, target)
	local isHtml
	_defaultParam = nil
	;(nil).fontName = ""
	;(nil).fontSize = _defaultParam.fontSize
	;(nil).fontAlignmentH = cc.TEXT_ALIGNMENT_LEFT
	;(nil).fontAlignmentV = cc.VERTICAL_TEXT_ALIGNMENT_TOP
	;(nil).fontDimensions = cc.size(0, 0)
	local (nil).isHtml, txtContentInfo = isHtml, nil
	local isVip = data.isVip
	local vipLv = data.vipLv or 0
	local name = data.name
	local align = data.align
	local isGM = data.isGM
	local str = data.name or ""
	local gametop = gModuleMgr.getObject("gametop")
	local currentKid
	if gametop.playertop_ then
		currentKid = gametop.playertop_:getKingdomID()
	end
	local kid = data.kid
	if kid ~= nil and kid ~= currentKid then
		name = name .. "#" .. kid
	end
	local measureTextSize = cc.Device:measureText(str, txtContentInfo)
	local nameWidth = measureTextSize.width
	local width = nameWidth
	if isGM then
		width = width + _defaultParam.gmSize.width
	end
	if isVip then
		local vipImage = SoraDSetVipImage(vipLv)
		width = width + vipImage:getContentSize().width
	end
	local height = _defaultParam.height
	return cc.size(width, height)
end
function chatNameNode:onThemeUpdate()
	local theme = self.data.theme
	theme = theme or gCurrentChatTheme
	if theme == gChatTheme.normal then
		self.text:setTextColor(_defaultParam.fontcolor)
	else
		self.text:setTextColor(_defaultParam.nightcolor)
	end
end
return chatNameNode
