local beastCanyonCtrl = SoraDGetCtrl("beastCanyonCtrl")
local baseComponent = require("fgui.base.baseComponent")
local Com_BossEnter = fgui.extension_class(fgui.GComponent, baseComponent)
fgui.register_extension("ui://BeastCanyon/Com_BossEnter", Com_BossEnter)
function Com_BossEnter:onInit()
	self:fixChildrenPos()
	self:addClickListener(handler(self, self.onClickBoss))
	self.fields.Usm_1:setPrepareCallback(function()
		self.isPrepred = true
		self.fields.Usm_1:getCriSprite():start()
		self:updateStatus()
	end)
end
function Com_BossEnter:onShow()
end
function Com_BossEnter:initData(activityID, data)
	self.activityID = activityID
	self.bossType = data.type
	self.openDayList = data.open
	self.bossName = data.name
	self.fields.title:setString(i18n(data.text))
	self.fields.Text_Buff:setString(i18n(data.tips))
	self.fields.Text_Name:setString(i18n(data.name))
	if self.activityID == gActivityTimeActivityID.NORMAL_ACTIVITY_9001650 then
		_UPVALUE3_ = self.activityID
		self.activityID[1] = "xingsxg_long"
		self.activityID[2] = "xingsxg_langren"
		local self.activityID[3], config = "xingsxg_ma", self.activityID
		self.fields.Spine_1:setEffectPath("spine/" .. config[self.bossType] .. ".skel")
		_UPVALUE2_ = self.fields.Spine_1.setEffectPath
		self.fields.Spine_1.setEffectPath[1] = cc.p(46, -144)
		self.fields.Spine_1.setEffectPath[2] = cc.p(14, -128)
		self.fields.Spine_1.setEffectPath[3] = cc.p(-10, -188)
		self.fields.Spine_1.setEffectPath[4] = cc.p(-10, -188)
		local self.fields.Spine_1.setEffectPath[5], config = cc.p(-10, -188)
		self.fields.Spine_1:setSpinePos(config[self.bossType])
		self.fields.Image_boss:setVisible(false)
		self.controllers.c_viewType:setSelectedIndex(1)
	else
		self.fields.Usm_1:setEffectPath(data.icon .. ".usm")
		self.fields.Usm_1:setBlendMode(fgui.BlendMode.Normal)
		self.controllers.c_viewType:setSelectedIndex(0)
	end
end
function Com_BossEnter:updateStatus()
	self.controllers.c_open:setSelectedIndex(0)
	if self.activityID == gActivityTimeActivityID.NORMAL_ACTIVITY_9001650 then
		if self:checkOpen() then
			self.controllers.c_open:setSelectedIndex(0)
			self.fields.Spine_1:updateSpineColor(cc.c3b(225, 225, 225))
			self.fields.Spine_1:start()
		else
			self.controllers.c_open:setSelectedIndex(1)
			self.fields.Spine_1:updateSpineColor(cc.c3b(100, 100, 100))
			self.fields.Spine_1:pause()
		end
	elseif self:checkOpen() then
		self.fields.Usm_1:getCriSprite():setColor(cc.c3b(225, 225, 225))
		if self.isPrepred then
			self.fields.Usm_1:getCriSprite():start()
		end
		self.controllers.c_open:setSelectedIndex(0)
	else
		self.fields.Usm_1:getCriSprite():setColor(cc.c3b(100, 100, 100))
		if self.isPrepred then
			self.fields.Usm_1:getCriSprite():pause()
		end
		self.controllers.c_open:setSelectedIndex(1)
	end
	self:setReddot(0 < beastCanyonCtrl:getChallengeTimes(self.activityID) and self:checkOpen(), -1)
end
function Com_BossEnter:onClickBoss()
	SoraDPlaySound()
	if self:checkOpen() then
		_ENV = nil
		;(nil).activityID = self.activityID
		;(nil).bossType = self.bossType
		uiManager:show("BeastCanyonFight", nil)
	else
		_ENV = nil
		;(nil).name = i18n(self.bossName)
		SoraDShowMsgTip(i18n("Divinebeastcanyon_text_15", nil))
	end
end
function Com_BossEnter:checkOpen()
	local weekDay = serviceFunctions.getWeekDayEx()
	for i, v in ipairs(self.openDayList) do
		if v == weekDay then
			return true
		end
	end
	return false
end
return Com_BossEnter
