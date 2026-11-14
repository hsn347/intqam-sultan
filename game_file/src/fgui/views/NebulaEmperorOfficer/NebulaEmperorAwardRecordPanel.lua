local nebulaWarRead = include("nebulaWarRead")
local nebulaEmperorRead = include("nebulaEmperorRead")
local nebulaEmperorCtrl = SoraDGetCtrl("nebulaEmperorCtrl")
local baseFguiPanel = require("fgui.base.baseFguiPanel")
local NebulaEmperorAwardRecordPanel = class("NebulaEmperorAwardRecordPanel", baseFguiPanel)
function NebulaEmperorAwardRecordPanel:ctor(...)
	self.super.ctor(self, ...)
	print("NebulaEmperorAwardRecordPanel:ctor", self.viewName)
end
function NebulaEmperorAwardRecordPanel:onInit()
	print("=======NebulaEmperorAwardRecordPanel:onInit")
	self.fields.Panel_bg:setString(i18n("nebulaemperor_text_25"))
	self.fields.List:setItemRenderer(handler(self, self.onItemRederer))
	self.fields.List:setVirtual()
	self.fields.Text_noData:setString(i18n("common_text_927"))
end
function NebulaEmperorAwardRecordPanel:onShow()
	print("=======NebulaEmperorAwardRecordPanel:onShow")
	nebulaEmperorCtrl:reqGiftRecord()
	SoraDShowLoading(self:displayObject())
end
function NebulaEmperorAwardRecordPanel:onItemRederer(index, obj)
	local record = self.recordList[#self.recordList - index]
	local regionId = record.regionId
	local areaAbbr = nebulaWarRead.getAreaAbbr(regionId)
	nebulaWarRead = nil
	;(nil).abbr = areaAbbr
	;(nil).name = record.nickname
	local target = i18n("common_text_186", nil)
	local box = nebulaEmperorRead.getPackageName(record.giftId)
	nebulaWarRead = nil
	;(nil).name = self.emperorName
	;(nil).target = target
	;(nil).box = box
	local recordStr = i18n("nebulaemperor_text_26", nil)
	obj:setString(recordStr)
	local _fields = fguiHelper.get_fields(obj)
	_fields.Image_line:setVisible(index % 2 ~= 0)
end
function NebulaEmperorAwardRecordPanel:onMsgReqGiftRecordRsp(target, event)
	SoraDCloseLoading(self:displayObject())
	if not event.rspdata then
		local _ENV, rspdata = event.rspdata, event.rspdata
	end
	if not rspdata.emperorInfo then
		local _ENV, info = rspdata.emperorInfo, rspdata.emperorInfo
	end
	if next(info) then
		local regionId = info.regionId
		local areaAbbr = nebulaWarRead.getAreaAbbr(regionId)
		_ENV = self:displayObject()
		self:displayObject().abbr = areaAbbr
		self:displayObject().name = info.nickname
		self.emperorName = i18n("common_text_186", self:displayObject())
	end
	if not rspdata.record then
		_ENV = rspdata.record
	end
	self.recordList = rspdata.record
	self.fields.List:setNumItems(#self.recordList)
	self.fields.Text_noData:setVisible(#self.recordList == 0)
end
return NebulaEmperorAwardRecordPanel
