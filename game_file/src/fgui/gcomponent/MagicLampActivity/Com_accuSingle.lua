local magicFlipCtrl = SoraDGetCtrl("magicFlipCtrl")
local nebulaActivityCtrl = SoraDGetCtrl("nebulaActivityCtrl")
local baseComponent = require("fgui.base.baseComponent")
local Com_accuSingle = fgui.extension_class(fgui.GComponent, baseComponent)
fgui.register_extension("ui://MagicLampActivity/Com_accuSingle", Com_accuSingle)
function Com_accuSingle:onInit()
	self:fixChildrenPos()
	self.fields.n0:fix(false)
	if SoraDFIsRA() then
		self.fields.Usm_1:setScaleX(-1)
	end
	self.fields.Ani_box:setAllFrameName("dh_jinengyj01_%03d.png", 0)
	self.fields.Com_Box:getChild("Movie"):setAllFrameName("dh_shendengbx_%02d.png", 1)
	self.fields.touch:addClickListener(handler(self, self.onClickGet))
	self.fields.List_reward:setItemRenderer(handler(self, self.onItemRenderer))
	self.fields.Text_Tip1:setString(i18n("magic_flip_9"))
	self.fields.Text_Tip2:setString(i18n("magic_flip_10"))
	self.iconPosY = self.fields.icon:getPositionY()
end
function Com_accuSingle:initData(data, otherData)
	self.activityID = otherData and otherData.activityID
	if self.activityID == gActivityTimeActivityID.NEBULA_REGION_ACTIVITY then
		self.cfg = data
		self.fields.Text_score:setString(string.formatnumberthousands(self.cfg.need))
		self.state = nebulaActivityCtrl:getScoreRewardState(self.cfg.need)
		self.reward = self.cfg.award
	else
		self.index = data.index
		self.score = data.num
		self.reward = data.reward
		self.type = data.type
		self.fields.Text_score:setString(self.score)
		self.state = magicFlipCtrl:getStageStatues(data.index, data.num)
	end
	print("self.state", self.state)
	self.fields.icon:setPositionY(self.iconPosY)
	self.fields.icon:setScale(1)
	if self.state == 0 then
		self.fields.icon:setURL((data.icon or "icon_starcube_box_01") .. ".png")
		self.controllers.c1:setSelectedIndex(0)
	elseif self.state == gMmagicFlipStatus.ALREADY_RECEIVE then
		self.fields.icon:setURL((data.iconOpen or "icon_starcube_box_01_open") .. ".png")
		self.controllers.c1:setSelectedIndex(2)
		self.fields.icon:setPositionY(self.iconPosY + 8)
		self.fields.icon:setScale(0.98)
	else
		self.fields.icon:setURL((data.icon or "icon_starcube_box_01") .. ".png")
		self.controllers.c1:setSelectedIndex(1)
	end
	if self.activityID == gActivityTimeActivityID.NEBULA_REGION_ACTIVITY then
		self.fields.List_reward:setNumItems(table.nums(self.reward) / 2)
		self.fields.List_reward:scrollToView(0)
	else
		if data.type == 1 then
			print("(table.nums(data.reward) / 2", table.nums(data.reward), table.nums(data.reward) / 2)
			self.fields.List_reward:setNumItems(table.nums(data.reward) / 2)
			self.fields.List_reward:scrollToView(0)
		end
		self.controllers.c2:setSelectedIndex(data.type - 1)
	end
end
function Com_accuSingle:onItemRenderer(index, object)
	object:initData(self.reward[index * 2 + 1], self.reward[index * 2 + 2], self.state == gMmagicFlipStatus.ALREADY_RECEIVE and 1 or 0)
end
function Com_accuSingle:onClickGet()
	SoraDPlaySound()
	if self.activityID == gActivityTimeActivityID.NEBULA_REGION_ACTIVITY then
		if self.state == gMmagicFlipStatus.CAN_RECEIVE then
			nebulaActivityCtrl:reqScoreReward(self.cfg.need)
		elseif self.state == gMmagicFlipStatus.ALREADY_RECEIVE then
			SoraDShowMsgTip(i18n("common_text_1892"))
		else
			local myScore = nebulaActivityCtrl:getPlayerScore()
			_ENV = i18n("common_text_1892")
			i18n("common_text_1892").num = string.formatnumberthousands(self.cfg.need - myScore)
			SoraDShowMsgTip(i18n("nebula_war_text_0526", i18n("common_text_1892")))
		end
	elseif self.state == gMmagicFlipStatus.CAN_RECEIVE then
		if self.type == 2 then
			SoraDShowMsgTip(i18n("magic_flip_10"))
		else
			magicFlipCtrl:reqMagicFlipStageReward(self.index)
		end
	end
end
function Com_accuSingle:onShow()
	self.fields.icon:setPositionX(self.fields.touch:getPositionX())
end
return Com_accuSingle
