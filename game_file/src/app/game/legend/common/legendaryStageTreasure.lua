local gametop = gModuleMgr.getObject("gametop")
local legendStageRewardCtrl = gametop.playertop_:getModule("legendStageRewardCtrl")
local legendaryStageTreasure = class("legendaryStageTreasure", function(target)
	local isCreateUI = false
	if isCreateUI then
		local view = include("baseView")
		return view.new(cc.size(0, 0), false)
	else
		if target == nil then
			return SoraDCreateBasePanel("legendaryStageTreasure")
		end
		if type(target) == "string" then
			return SoraDCreateBasePanel(target)
		end
		return target
	end
end)
function legendaryStageTreasure:ctor()
	self:createUI()
	self.imgBg = SoraDGetChildByName(self, "Image_bg")
	self.nodeEffectBg = SoraDGetChildByName(self, "Node_effect_bg")
	self.particle1 = SoraDGetChildByName(self, "Particle_1")
	self.particle2 = SoraDGetChildByName(self, "Particle_2")
	self.btnIcon = SoraDGetChildByName(self, "btn_icon")
	self.imgIcon = SoraDGetChildByName(self, "img_icon")
	self.nodeEffectTop = SoraDGetChildByName(self, "Node_effect_top")
	self.particle5 = SoraDGetChildByName(self, "Particle_5")
	self.iconLock = SoraDGetChildByName(self, "icon_lock")
	self.iconLock2 = SoraDGetChildByName(self, "icon_lock_1")
	self.iconYes = SoraDGetChildByName(self, "icon_yes")
	self.nodeScore = SoraDGetChildByName(self, "Node_score")
	self.imgBg = SoraDGetChildByName(self, "Image_bg")
	self.txtTitle = SoraDGetChildByName(self, "txt_title")
	self.imgBg:setVisible(false)
	self.particle5:setVisible(false)
	self.btnIcon:addTouchEventListener(handler(self, self.onClick_btnIcon))
end
function legendaryStageTreasure:createUI()
	local CCSUICreator = include("CCSUICreator")
end
function legendaryStageTreasure:init(data)
	self.data = data
	local isOpen = false
	if data.score >= data.needScore then
		self.iconYes:setVisible(true)
		self.iconLock:setVisible(false)
		if self.iconLock2 then
			self.iconLock2:setVisible(false)
		end
		isOpen = true
	else
		self.iconYes:setVisible(false)
		self.iconLock:setVisible(true)
		if self.iconLock2 then
			self.iconLock2:setVisible(true)
		end
	end
	if self.data.rewardType == gLegendStageRewardType.PERSONAL then
		if isOpen then
			self.imgIcon:loadTexture("icon_recruitsupplies_box_02.png", ccui.TextureResType.plistType)
			self.imgIcon:setScale(0.9)
		else
			self.imgIcon:loadTexture("icon_recruitsupplies_box_01.png", ccui.TextureResType.plistType)
			self.imgIcon:setScale(1.0)
		end
		local stageInfo = legendStageRewardCtrl:getStageInfo()
		local personStageInfo = stageInfo.personStageInfo
		dump(personStageInfo, "personStageInfo", 10)
		self.receiveStatus = personStageInfo[tostring(data.stage)] and personStageInfo[tostring(data.stage)].receiveStatus or 0
	elseif self.data.rewardType == gLegendStageRewardType.ALLIANCE then
		if isOpen then
			self.imgIcon:loadTexture("icon_everydayVIP_box_open.png", ccui.TextureResType.plistType)
		else
			self.imgIcon:loadTexture("icon_everydayVIP_box_close.png", ccui.TextureResType.plistType)
		end
		self.imgIcon:setScale(1.2)
		local stageInfo = legendStageRewardCtrl:getStageInfo()
		local allianceStageInfo = stageInfo.allianceStageInfo
		self.receiveStatus = allianceStageInfo[tostring(data.stage)] and allianceStageInfo[tostring(data.stage)].receiveStatus or 0
		if self.receiveStatus == gAllianceReceiveStatus.CANNOT_RECEIVE then
			SoraDSetNodeGray(self.imgIcon, true)
			self:setEffectVisible(false)
			self.iconYes:setVisible(false)
		end
	end
	if data.stageType == gLegendStageType.KING_STAR then
		SoraDSetNodeGray(self.imgIcon, data.score < data.needScore)
		self:setEffectVisible(data.score > data.needScore)
		self.txtTitle:setColor(data.score < data.needScore and cc.c3b(120, 120, 120) or cc.c3b(255, 210, 70))
	end
end
function legendaryStageTreasure:setEffectVisible(isVisible)
	self.nodeEffectBg:setVisible(isVisible)
	self.nodeEffectTop:setVisible(isVisible)
end
function legendaryStageTreasure:setTitle(title)
	self.txtTitle:setString(title)
end
function legendaryStageTreasure:onMessageListener()
end
function legendaryStageTreasure:onClick_btnIcon(sender, event)
	if event == ccui.TouchEventType.ended then
		SoraDPlaySound()
		if SoraDGetCtrl("legendTeamCtrl"):isTeamCommander() then
			SoraDShowMsgTip(i18n("legendary_commander_text27"))
			return
		end
		if self.data.rewardType == gLegendStageRewardType.PERSONAL then
			local panelRewardPreview = SoraDCreatePanel("legendaryStageRewardPreview")
			panelRewardPreview:init(self.data)
			panelRewardPreview:show()
		elseif self.data.rewardType == gLegendStageRewardType.ALLIANCE then
			if self.receiveStatus == gAllianceReceiveStatus.CANNOT_RECEIVE then
				SoraDShowMsgTip(i18n("common_text_3152"))
				return
			end
			local panelRewardPreview = SoraDCreatePanel("legendaryStageRewardPreview")
			panelRewardPreview:init(self.data)
			panelRewardPreview:show()
		end
	end
end
return legendaryStageTreasure
