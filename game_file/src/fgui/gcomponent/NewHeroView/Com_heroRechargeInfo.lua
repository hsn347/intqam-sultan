local rechargeltCtrl = include("rechargeltCtrl")
local baseComponent = require("fgui.base.baseComponent")
local Com_heroRechargeInfo = fgui.extension_class(fgui.GComponent, baseComponent)
fgui.register_extension("ui://NewHeroView/Com_heroRechargeInfo", Com_heroRechargeInfo)
function Com_heroRechargeInfo:onInit()
	self.awardList, _ENV = nil, nil
	self.fields.Text_Info:setString(i18n("herogift_text_01"))
	self.fields.Text_Title:setString(i18n("pray_text_11"))
	self.fields.Text_TimeTitle:setString(i18n("common_text_2669"))
	self.Text_Time = SoraDCreateTimerLabel(self, self.fields.Text_Time)
	self.fields.List:setItemRenderer(handler(self, self.onItemRederer))
	self.fields.List:setAlignCenter(true)
	self.fields.List:autoFix()
	self.fields.List:setNeedAutoFix(false)
	self.fields.Text_Info:fixPos()
	self.fields.Text_TimeTitle:fixPos()
	self.fields.Text_Time:fixPos()
	self.fields.Text_Title:fixPos()
	self.fields.Image_Lang:setPivot(SoraDFIsRA() and 1 or 0, 1)
end
function Com_heroRechargeInfo:onShow()
end
function Com_heroRechargeInfo:initData(info)
	self.fields.Image_Lang:setURL(string.format("frame_font_hero_%s_%s.png", info.heroID, SoraDFIsRA() and "ar" or "en"))
	if self.fields.Image_Lang:getWidth() > 320 then
		self.fields.Image_Lang:setScale(320 / self.fields.Image_Lang:getWidth())
	else
		self.fields.Image_Lang:setScale(1)
	end
	self.fields.Image_Lang:setPosition(SoraDFIsRA() and cc.p(self:getWidth() - self.fields.Image_Lang:getWidth() - 20, 50) or cc.p(20, 0))
	self.Text_Time:beginTime(info.endTime - serviceFunctions.systemTime())
	local giftInfo = rechargeltCtrl.getHeroRecruitInfo(info.heroID)
	_UPVALUE2_ = serviceFunctions.systemTime()
	serviceFunctions.systemTime()[1] = "id"
	serviceFunctions.systemTime()[2] = "count"
	self.awardList = serviceFunctions.tableFormat(giftInfo.gift, (serviceFunctions.systemTime()))
	self.fields.List:setNumItems(#self.awardList)
	self.fields.List:setScrollEnable(#self.awardList * 100 > self:getWidth())
end
function Com_heroRechargeInfo:onItemRederer(index, target)
	target:initData(self.awardList[index + 1].id, self.awardList[index + 1].count)
end
return Com_heroRechargeInfo
