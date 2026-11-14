local mailFunctions = include("mailFunctions")
local mailUIConstDef = include("mailUIConstDef")
local mailDesParser = include("mailDesParser")
local mailNodeFactory = include("mailNodeFactory")
local mailItemBossReport = class("mailItemBossReport", function(target)
	local target = ccui.Layout:create()
	target = include("mailItemRewardRecycle").new(target)
	return target
end)
function mailItemBossReport:ctor()
	self:setCascadeOpacityEnabled(true)
	self:setLayoutType(ccui.LayoutType.VERTICAL)
	self.totalWidth = gMailDetaiViewWidth
	self:initWidget()
end
function mailItemBossReport:initWidget(...)
	mailNodeFactory = nil
	;(nil).imgName = SoraDFIsRA() and "bg_mail_worldboss_ar.png" or "bg_mail_worldboss_en.png"
	;(nil).imagHeight = 137
	;(nil).imagWidth = 640
	;(nil).scale = 0.86
	;(nil).point = cc.p(0.5, 0.5)
	self.imageView = mailNodeFactory:createImgViewLayout(nil)
	self.imageView:addTo(self)
	mailNodeFactory = self
	self.str = "unDefined"
	self.name = "text_title"
	self.fontSize = 22
	self.color = cc.c3b(57, 11, 11)
	self.AlignH = cc.VERTICAL_TEXT_ALIGNMENT_CENTER
	mailNodeFactory, self.linearLayoutType = ccui.LinearGravity.centerHorizontal, ccui.LinearGravity.centerHorizontal
	ccui.LinearGravity.centerHorizontal.left = 0
	ccui.LinearGravity.centerHorizontal.top = 15
	ccui.LinearGravity.centerHorizontal.right = 0
	self.margin, ccui.LinearGravity.centerHorizontal.bottom = ccui.LinearGravity.centerHorizontal, 0
	self.layout_des = mailNodeFactory:createTextLayout(self)
	self.layout_des:addTo(self)
	self.summaryNode = SoraDCreatePanel("mailWorldBossSummary")
	self.summaryNode:addTo(self)
	self.layout_head = mailNodeFactory:createLayoutRewardItemHead()
	self.layout_head:addTo(self)
	self.rewardLayout = ccui.VBox:create()
	self.rewardLayout:addTo(self)
	self.monsterInfoNode = SoraDCreatePanel("mailItemDetailMonsterSummary")
	self.monsterInfoNode:addTo(self)
end
function mailItemBossReport:initAnchorAndPosition(widget)
	widget:addTo(self)
	widget:setSwallowTouches(false)
	widget:setAnchorPoint(cc.p(0.5, 0))
	widget:setPositionX(self.totalWidth / 2)
end
function mailItemBossReport:refreshData(mail)
	self.mail = mail
	local contentData = self.mail:getProperty("data")
	local totalWidth = self.totalWidth
	local totalHeight = 0
	local contentType = contentData.contentType
	if contentType == gMailNPCContentType.Content_HeroBoss_AttackBySelf or contentType == gMailNPCContentType.Content_WorldBoss_KillReward or contentType == gMailNPCContentType.Content_WorldBoss_KillRewardOverFlow then
		self.imageView:setVisible(true)
	else
		self.imageView:setVisible(false)
	end
	self.layout_des:setString(mailDesParser.getTextTip(self.mail))
	SoraDGetAutoHeightLabel(self.layout_des, 443)
	totalHeight = totalHeight + mailNodeFactory:getWidgetItemHeight(self.layout_des)
	if contentData.content and contentData.content.coordinate and not contentData.content.coordinate.kid then
		contentData.content.coordinate.kid = self.mail:getKingdomID()
	end
	self.summaryNode:initWithData(contentData)
	if contentData.reward and contentData.reward.items and next(contentData.reward.items) then
		self.layout_head:setVisible(true)
		self.rewardLayout:setVisible(true)
		self:recycleRewardItems(self.rewardLayout)
		self:createLayoutMonsterRewardItem(contentData, self.rewardLayout)
	else
		self.layout_head:setVisible(false)
		self.rewardLayout:setVisible(false)
	end
	self.monsterInfoNode:initWithData(contentData.content)
	_UPVALUE5_ = self.monsterInfoNode
	self.monsterInfoNode[1] = "imageView"
	self.monsterInfoNode[2] = "summaryNode"
	self.monsterInfoNode[3] = "layout_head"
	self.monsterInfoNode[4] = "rewardLayout"
	self.monsterInfoNode[5] = "monsterInfoNode"
	for i, v in ipairs(self.monsterInfoNode) do
		local widget = self[v]
		if widget and widget:isVisible() then
			local lp3 = ccui.LinearLayoutParameter:create()
			lp3:setGravity(ccui.LinearGravity.centerHorizontal)
			widget:setLayoutParameter(lp3)
			widget:setSwallowTouches(false)
			totalHeight = totalHeight + mailNodeFactory:getWidgetItemHeight(widget)
		else
			local lpFrame = ccui.LayoutParameter:create()
			widget:setLayoutParameter(lpFrame)
		end
	end
	self:setContentSize(cc.size(totalWidth, totalHeight))
	local curHeight = totalHeight
	self:requestDoLayout()
end
return mailItemBossReport
