local publicRead = include("publicRead")
local baseComponent = require("fgui.base.baseComponent")
local list_textsingle = fgui.extension_class(fgui.GComponent, baseComponent)
fgui.register_extension("ui://angerSnowWolf/list_textsingle", list_textsingle)
function list_textsingle:onInit()
	self:fixChildrenPos()
end
function list_textsingle:onShow()
end
function list_textsingle:initData(data, index)
	_ENV = nil
	;(nil).name = data.userinfo.nickName
	local txtDes = i18n("Challenge_SnowWolf_text_02", nil)
	if data.userinfo.allianceName then
		_ENV = data.userinfo.nickName
		_ENV = nil
		;(nil).abbr = data.userinfo.allianceName
		;(nil).name = data.userinfo.nickName
		data.userinfo.nickName.name = i18n("common_text_186", nil)
		txtDes = i18n("Challenge_SnowWolf_text_02", data.userinfo.nickName)
	end
	self.fields.Text_info:setString(txtDes)
	self.fields.Text_time:setString(SoraDConvertTimeToDate(data.t, false, true))
	local itemDes = ""
	if data.awarddata.item and next(data.awarddata.item) then
		_ENV = SoraDConvertTimeToDate(data.t, false, true)
		SoraDConvertTimeToDate(data.t, false, true).good = publicRead.getName(data.awarddata.item[1]) .. "*" .. data.awarddata.item[2]
		itemDes = i18n("common_text_3276", SoraDConvertTimeToDate(data.t, false, true))
	elseif data.awarddata.superaward and next(data.awarddata.superaward) then
		_ENV = SoraDConvertTimeToDate(data.t, false, true)
		SoraDConvertTimeToDate(data.t, false, true).good = publicRead.getName(data.awarddata.superaward[1]) .. "*" .. data.awarddata.superaward[2]
		itemDes = i18n("common_text_3276", SoraDConvertTimeToDate(data.t, false, true))
	end
	self.fields.Text_event:setString(itemDes)
	self.fields.nbg:setVisible(index % 2 == 1)
end
return list_textsingle
