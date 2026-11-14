local gametop = gModuleMgr.getObject("gametop")
local devilValleyCtrl = gametop.playertop_:getModule("devilValleyCtrl")
local newTrialRead = include("newTrialRead")
local showCount = newTrialRead.showCount
local showLineMax = 3
local newTrialSelectView = class("newTrialSelectView", function(target)
	if target == nil then
		return SoraDCreateTouchPanel("newTrialSelectView")
	end
	return target
end)
function newTrialSelectView:ctor()
	self.ccs_bg = SoraDGetExtendChildFromCCSByName(self, "CCS_commonPopBox_bg")
	self.ccs_bg:setTitleName(i18n("remains_text_201"))
	self.levelList, _ENV = self.ccs_bg.setTitleName, self.ccs_bg.setTitleName
	local nodeCreate = SoraDGetChildByName(self, "Button_node")
	local nodeContent = SoraDGetChildByName(self, "Node_content")
	local posNodeY = nodeCreate:getPositionY()
	for i = 1, showCount do
		local node
		if i == 1 then
			node = nodeCreate
		else
			node = nodeCreate:clone()
			node:addTo(nodeContent, 1)
		end
		local posX = SoraDFPosX(500 - (i - 1) % showLineMax * 180, 640)
		node:setPositionX(posX)
		local posY = posNodeY - math.floor((i - 1) / showLineMax) * 160 + 20
		node:setPositionY(posY)
		table.insert(self.levelList, node)
	end
	self:initCreatePanel()
end
function newTrialSelectView:initCreatePanel()
	for i = 1, showCount do
		self:createChooseItem(self.levelList[i], i, function(mtype, type)
			if not devilValleyCtrl:checkChallengeLv(mtype) then
				SoraDShowMsgTip(i18n("devilvalley_text_51"))
			elseif not devilValleyCtrl:checkCastleCondition(mtype) then
				local lvLimit = newTrialRead.getCastleCondition(mtype)
				local transLevel = function(bLevel)
					local buildLogic = include("buildLogic")
					local warLv = buildLogic.transformBuildLvToWarLv(bLevel)
					if 0 < warLv then
						_ENV = nil
						;(nil).lv = warLv
						return i18n("common_text_1948", nil)
					else
						return math.min(bLevel, _G.CASTLE_MAXLV_NOWAR)
					end
				end
				local lv = transLevel(lvLimit)
				devilValleyCtrl = i18n("devilvalley_text_51")
				i18n("devilvalley_text_51").lv = lv
				SoraDShowMsgTip(i18n("common_text_3868", i18n("devilvalley_text_51")))
			else
				devilValleyCtrl:sendReqCreateTeam(mtype)
				self:removeFromParent()
			end
		end)
	end
end
function newTrialSelectView:createChooseItem(item, mtype, handle)
	item.Sprite_lock = SoraDGetChildByName(item, "Node_lock")
	item.Text_name = SoraDGetChildByName(item, "Text_name")
	item.imgBg = SoraDGetChildByName(item, "Icon_bg")
	local info = newTrialRead.getChallengeInfo(mtype)
	if info then
		item.imgBg:setSpriteFrame(info.btnbg)
		item.Text_name:setString(i18n(info.name))
		item.Text_name:setColor(info.color)
	end
	item:setTouchEnabled(true)
	item:addTouchEventListener(function(button, type)
		if type ~= ccui.TouchEventType.ended then
			return
		end
		SoraDPlaySound()
		if handle then
			handle(mtype, type)
		end
	end)
	if item.Sprite_lock then
		if not devilValleyCtrl:checkChallengeLv(mtype) then
			item.Sprite_lock:setVisible(true)
			item.Text_name:setVisible(false)
		else
			item.Sprite_lock:setVisible(false)
			item.Text_name:setVisible(true)
		end
	end
	return item
end
return newTrialSelectView
