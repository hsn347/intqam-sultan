local buffCtrl = SoraDGetCtrl("buffCtrl")
local buffltCtrl = gModuleMgr.sharedMgr("buffltCtrl")
local buffDesRead = include("buffDesRead")
local sultansBackRead = include("sultansBackRead")
local sultansBackWelBackSingle = class("sultansBackWelBackSingle", function(target)
	if target == nil then
		return SoraDCreateBasePanel("sultansBackWelBackSingle")
	end
	return target
end)
function sultansBackWelBackSingle:ctor()
	self.Image_buff = SoraDGetChildByName(self, "Image_buff")
	self.Text_name = SoraDGetChildByName(self, "Text_name")
	self.Text_des = SoraDGetChildByName(self, "Text_des")
	self.Text_time = SoraDGetChildByName(self, "Text_time")
	self.Text_time = SoraDCreateTimerLabel(self, self.Text_time)
end
function sultansBackWelBackSingle:initData(buff, otherData)
	self.buff = buff
	self.buffType = buffltCtrl:getEffectType(self.buff)
	self.buffValue = buffltCtrl:getEffect(self.buff)
	self.Image_buff:loadTexture(sultansBackRead.getWelBackBuffIcon(self.buff), ccui.TextureResType.plistType)
	self.Text_name:setString(buffDesRead.getTitleBase(self.buffType))
	self.Text_des:setString(buffDesRead.getTitleWithValue(self.buffType, self.buffValue))
	local remainTime = buffCtrl:getRemainTimeByBuffID(self.buff)
	if remainTime then
		self.Text_time:setTimeLast(function(time)
			_ENV = nil
			;(nil).time = time
			return i18n("welcome_back_text07", nil)
		end)
		self.Text_time:beginTime(remainTime)
	end
end
return sultansBackWelBackSingle
