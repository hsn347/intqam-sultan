local allianceTreasureltCtrl = include("allianceTreasureltCtrl")
local baseComponent = require("fgui.base.baseComponent")
local allianceStoreHouseRecordSingle = fgui.extension_class(fgui.GComponent, baseComponent)
fgui.register_extension("ui://AllianceStoreHouseView/allianceStoreHouseRecordSingle", allianceStoreHouseRecordSingle)
function allianceStoreHouseRecordSingle:onInit()
	self:fixChildrenPos()
end
function allianceStoreHouseRecordSingle:onShow()
end
function allianceStoreHouseRecordSingle:initData(data, recordType)
	self.recordType = recordType
	self.fields.Text_time:setString(os.date("%m-%d %H:%M", data.time))
	local desStr = self:getDesStr(data.event) or ""
	local treasure = ""
	if data.treasure and data.treasure.teasureID and data.treasure.quality then
		treasure = allianceTreasureltCtrl.getTreasureName(data.treasure.teasureID, data.treasure.quality)
	end
	local name = data.name or ""
	_ENV = os.date("%m-%d %H:%M", data.time)
	os.date("%m-%d %H:%M", data.time).treasure = treasure
	os.date("%m-%d %H:%M", data.time).name = name
	self.fields.Text_des:setString(i18n(desStr, os.date("%m-%d %H:%M", data.time)))
end
function allianceStoreHouseRecordSingle:getDesStr(subType)
	_UPVALUE0_, _UPVALUE0_ = nil, nil
	;(nil)[1] = "allitreas_text_32_ros"
	;(nil)[2] = "allitreas_text_33_ros"
	;(nil)[3] = "allitreas_text_34_ros"
	_UPVALUE0_, (nil)[1], (nil)[4] = nil, nil, "allitreas_text_35_ros"
	;(nil)[1] = "allitreas_text_36_ros"
	;(nil)[2], (nil)[2] = nil, "allitreas_text_37_ros"
	local recordConfig
	local config = recordConfig[self.recordType]
	return config and config[subType] or ""
end
return allianceStoreHouseRecordSingle
