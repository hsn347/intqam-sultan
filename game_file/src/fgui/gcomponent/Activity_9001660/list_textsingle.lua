local publicRead = include("publicRead")
local activity_9001660_Ctrl = SoraDGetCtrl("activity_9001660_Ctrl")
local baseComponent = require("fgui.base.baseComponent")
local list_textsingle = fgui.extension_class(fgui.GComponent, baseComponent)
fgui.register_extension("ui://Activity_9001660/list_textsingle", list_textsingle)
function list_textsingle:onInit()
	self:fixChildrenPos()
end
function list_textsingle:onShow()
end
function list_textsingle:initData(data, index)
	_ENV = nil
	;(nil).name = data.userinfo.nickName
	;(nil).item = publicRead.getName(activity_9001660_Ctrl:getItemID())
	local txtDes = i18n("mutated_tentacles_text12", nil)
	if data.userinfo.allianceName then
		_ENV = publicRead.getName(activity_9001660_Ctrl:getItemID())
		_ENV = activity_9001660_Ctrl:getItemID()
		activity_9001660_Ctrl:getItemID().abbr = data.userinfo.allianceName
		activity_9001660_Ctrl:getItemID().name = data.userinfo.nickName
		publicRead.getName(activity_9001660_Ctrl:getItemID()).name = i18n("common_text_186", activity_9001660_Ctrl:getItemID())
		publicRead.getName(activity_9001660_Ctrl:getItemID()).item = publicRead.getName(activity_9001660_Ctrl:getItemID())
		txtDes = i18n("mutated_tentacles_text12", (publicRead.getName(activity_9001660_Ctrl:getItemID())))
	end
	self.fields.Text_info:setString(txtDes)
	self.fields.Text_time:setString(SoraDConvertTimeToDate(data.t, false, true))
	local itemDes = ""
	if data.awarddata.item and next(data.awarddata.item) then
		_ENV = SoraDConvertTimeToDate(data.t, false, true)
		SoraDConvertTimeToDate(data.t, false, true).good = publicRead.getName(data.awarddata.item[1]) .. "*" .. data.awarddata.item[2]
		itemDes = i18n("common_text_3276", SoraDConvertTimeToDate(data.t, false, true))
		self.fields.Com_item:initData(data.awarddata.item[1], data.awarddata.item[2])
	elseif data.awarddata.superaward and next(data.awarddata.superaward) then
		_ENV = data.awarddata.item[1]
		data.awarddata.item[1].good = publicRead.getName(data.awarddata.superaward[1]) .. "*" .. data.awarddata.superaward[2]
		itemDes = i18n("common_text_3276", data.awarddata.item[1])
		self.fields.Com_item:initData(data.awarddata.superaward[1], data.awarddata.superaward[2])
	end
	self.fields.Text_event:setString(itemDes)
	self.fields.nbg:setVisible(index % 2 == 1)
end
return list_textsingle
