local beastCanyonRead = include("beastCanyonRead")
local baseComponent = require("fgui.base.baseComponent")
local Com_ProgressBox = fgui.extension_class(fgui.GComponent, baseComponent)
fgui.register_extension("ui://BeastCanyon/Com_ProgressBox", Com_ProgressBox)
function Com_ProgressBox:onInit()
	self:fixChildrenPos()
	self.fields.Com_Bar:fixChildrenPos()
	self.fields.Movie_1:fix()
	self.fields.Movie_1:setAllFrameName("dh_xiagujdt_%02d.png", 1)
	self.fields.Movie_1:setVisible(false)
	self.fields.Movie_2:setAllFrameName("dh_xiagubk_%02d.png", 1)
	self.fields.Movie_2:setVisible(false)
	self.delayTime = 0.21666666666666667
end
function Com_ProgressBox:onShow()
end
function Com_ProgressBox:setDamage(activityID, bossType, damage)
	local num, maxNum = beastCanyonRead.getBoxNumAndNextNum(activityID, bossType, damage)
	self.fields.Com_Bar:setMax(maxNum)
	self.fields.Com_Bar:setValue(math.min(maxNum, damage))
	self.fields.Label_Num:setString(num)
	beastCanyonRead = math.min(maxNum, damage)
	math.min(maxNum, damage).member = string.formatnumberthousands(math.min(maxNum, damage))
	math.min(maxNum, damage).total = string.formatnumberthousands(maxNum)
	self.fields.Text_Bar:setString(i18n("common_text_155", math.min(maxNum, damage)))
end
function Com_ProgressBox:resetBar()
	self.endIndex = 0
	self.damage = 0
	self.fields.Com_Bar:setMax(0)
	self.fields.Com_Bar:setValue(0)
end
function Com_ProgressBox:runDamageAction(activityID, bossType, damage)
	self.damage = self.damage + damage
	self.boxNum = beastCanyonRead.getBoxNumAndNextNum(activityID, bossType, self.damage)
	self.config = beastCanyonRead.getBossReward(activityID, bossType)
	for i, v in ipairs(self.config) do
		if self.damage < v.num then
			self.newIndex = i
			break
		end
	end
	if not self.newIndex then
		self.newIndex = #self.config
	end
	print(self.newIndex, self.damage, "newIndex")
	self:runBarEffect()
end
function Com_ProgressBox:runBarEffect()
	if self.endIndex == self.newIndex then
		if self.fields.Com_Bar:getMax() ~= self.config[self.endIndex].num then
			self.fields.Com_Bar:setValue(0)
		end
		self.fields.Com_Bar:setMax(self.config[self.endIndex].num)
		self.fields.Com_Bar:tweenValue(self.damage, self.delayTime)
		_ENV = nil
		;(nil).member = string.formatnumberthousands(self.damage)
		;(nil).total = string.formatnumberthousands(self.config[self.endIndex].num)
		self.fields.Text_Bar:setString(i18n("common_text_155", nil))
	else
		local index = self.newIndex - 1
		local maxNum = self.config[index].num
		if self.config[self.newIndex].num <= self.damage then
			maxNum = self.config[self.newIndex].num
			index = self.newIndex
		end
		self.fields.Movie_1:setVisible(true)
		self.fields.Movie_1:setPlaySettings(0, -1, 1, -1)
		if self.fields.Com_Bar:getMax() ~= maxNum then
			self.fields.Com_Bar:setValue(0)
		end
		self.fields.Com_Bar:setMax(maxNum)
		_ENV = 1
		;(1).member = string.formatnumberthousands(maxNum)
		;(1).total = string.formatnumberthousands(maxNum)
		self.fields.Text_Bar:setString(i18n("common_text_155", 1))
		self.fields.Label_Num:setString(self.boxNum)
		self.fields.Com_Bar:tweenValue(maxNum, self.delayTime)
		_UPVALUE1_ = self.delayTime
		self.delayTime[1] = ffa.delay(self.delayTime)
		self.delayTime[2] = ffa.callFunc(function()
			self.fields.Movie_2:setVisible(true)
			self.fields.Movie_2:setPlaySettings(0, -1, 1, -1, function()
				self.fields.Movie_1:setVisible(false)
				self.fields.Movie_2:setVisible(false)
			end)
			self = self.fields.Movie_2
			self.fields.Movie_2.msg = "MESSAGE_ACTIVITY_9001547_UPDATE"
			self.fields.Movie_2.subMsg = "addBox"
			self.fields.Movie_2.index = index
			SoraDSendMessage(self.fields.Movie_2)
			self.endIndex = self.newIndex
			self:runBarEffect()
		end)
		self.delayTime[3] = ffa.callFunc(function()
			self.fields.Movie_2:setVisible(true)
			self.fields.Movie_2:setPlaySettings(0, -1, 1, -1, function()
				self.fields.Movie_1:setVisible(false)
				self.fields.Movie_2:setVisible(false)
			end)
			self = self.fields.Movie_2
			self.fields.Movie_2.msg = "MESSAGE_ACTIVITY_9001547_UPDATE"
			self.fields.Movie_2.subMsg = "addBox"
			self.fields.Movie_2.index = index
			SoraDSendMessage(self.fields.Movie_2)
			self.endIndex = self.newIndex
			self:runBarEffect()
		end)
		self:runAction(ffa.seq(self.delayTime))
	end
end
return Com_ProgressBox
