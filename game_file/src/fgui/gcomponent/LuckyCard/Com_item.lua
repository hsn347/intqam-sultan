local loginRewardCtrl = SoraDGetCtrl("loginRewardCtrl")
local dailyLoginRead = include("dailyLoginRead")
local baseComponent = require("fgui.base.baseComponent")
local Com_item = fgui.extension_class(fgui.GComponent, baseComponent)
fgui.register_extension("ui://LuckyCard/Com_item", Com_item)
function Com_item:onInit()
end
function Com_item:onShow()
end
function Com_item:initData(day)
	print("data", day)
	local dayData = dailyLoginRead.getLoginAwardByDay(day)
	local record = loginRewardCtrl:getRecord(day)
	if record then
		self.fields.Icon_flip:setURL(string.format("frame_mrwzyh_dl_x%d.png", record))
	end
	_ENV = string.format("frame_mrwzyh_dl_x%d.png", record)
	string.format("frame_mrwzyh_dl_x%d.png", record).day = day
	self.fields.title:setString(i18n("common_text_3723", string.format("frame_mrwzyh_dl_x%d.png", record)))
	local award = dayData.reward
	self.fields.Com_Item:initData(award[1].id, award[1].count)
	local curDay = loginRewardCtrl:getCurDay()
	local isGet = loginRewardCtrl:getCanReceive()
	if day > curDay or curDay == day and isGet then
		self.controllers.c1:setSelectedIndex(0)
	else
		self.controllers.c1:setSelectedIndex(1)
	end
	self:setEffectVisible(dayData.extraShow == 1)
end
function Com_item:setEffectVisible(ret)
	self.fields.Particle_1:setVisible(ret)
	self.fields.Particle_2:setVisible(ret)
end
return Com_item
