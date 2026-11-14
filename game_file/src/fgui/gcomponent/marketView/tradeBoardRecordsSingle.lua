local publicRead = include("publicRead")
local baseComponent = require("fgui.base.baseComponent")
local tradeBoardRecordsSingle = fgui.extension_class(fgui.GComponent, baseComponent)
fgui.register_extension("ui://marketView/tradeBoardRecordsSingle", tradeBoardRecordsSingle)
function tradeBoardRecordsSingle:onInit()
	self:fixChildrenPos()
end
function tradeBoardRecordsSingle:onShow()
end
function tradeBoardRecordsSingle:initData(data)
	if data == nil then
		return
	end
	local str, color = self:judgeByType(data)
	self.fields.Text_single:setString(str)
	self.fields.Text_single:setColor(color)
end
function tradeBoardRecordsSingle:judgeByType(info)
	local lT = info.logType
	if info.num then
		_ENV = nil
		;(nil).name = publicRead.getName(info.item)
		;(nil).count = info.num
		if i18n("common_text_1460", nil) then
			goto lbl_20
		end
	end
	local itemName = publicRead.getName(info.item)
	::lbl_20::
	local timeInfo = info.time and SoraDConvertTimeToDate(info.time, false, true) or ""
	self.fields.Text_time:setString(timeInfo)
	local ret = ""
	local color = cc.c3b(215, 195, 155)
	if gSalesRoomLogType.SELF_FIRST_PRICE == lT then
		_ENV = 155
		;(155).time = timeInfo
		;(155).item = itemName
		ret = i18n("common_text_2828", 155)
	elseif gSalesRoomLogType.MORE_THAN_MY_PRICE == lT then
		_ENV = 155
		;(155).time = timeInfo
		;(155).item = itemName
		;(155).gold = info.myGold
		ret = i18n("common_text_2816", 155)
		color = cc.c3b(190, 40, 40)
	elseif gSalesRoomLogType.MORE_THAN_OTHER_PRICE == lT then
		_ENV = 40
		;(40).time = timeInfo
		;(40).item = itemName
		;(40).lord = info.otherInfo.nickName
		;(40).num = info.otherInfo.kid
		ret = i18n("common_text_2827", 40)
	elseif gSalesRoomLogType.SELF_GET_ITEM == lT then
		_ENV = 40
		;(40).time = timeInfo
		;(40).item = itemName
		ret = i18n("common_text_2826", 40)
	elseif gSalesRoomLogType.OTHER_GET_ITEM == lT then
		_ENV = 40
		;(40).time = timeInfo
		;(40).item = itemName
		;(40).lord = info.otherInfo.nickName
		;(40).num = info.otherInfo.kid
		ret = i18n("common_text_2817", 40)
		color = cc.c3b(190, 40, 40)
	end
	return ret, color
end
function tradeBoardRecordsSingle:initDataEx(data, itemInfo)
	local str, color = self:judgeByTypeEx(data, itemInfo)
	self.fields.Text_single:setString(str)
	self.fields.Text_single:setColor(color)
end
function tradeBoardRecordsSingle:judgeByTypeEx(info, itemInfo)
	_ENV = nil
	;(nil).name = publicRead.getName(itemInfo.id)
	;(nil).count = itemInfo.count
	local itemName = i18n("common_text_1460", nil)
	local timeInfo = info.time and SoraDConvertTimeToDate(info.time, false, true) or ""
	self.fields.Text_time:setString(timeInfo)
	local ret = ""
	local color = cc.c3b(215, 195, 155)
	if info.logType and info.logType == gSalesRoomLogType.MORE_THAN_MY_PRICE then
		if info.costid == gIDDef.BORE then
			_ENV = 155
			;(155).item = itemName
			ret = i18n("auction_text_11", 155)
		else
			_ENV = 155
			;(155).item = itemName
			ret = i18n("auction_text_10", 155)
		end
		color = cc.c3b(190, 40, 40)
	elseif info.costid == gIDDef.BORE then
		_ENV = 40
		;(40).name = info.name2
		;(40).kid = info.kid2
		;(40).item = itemName
		;(40).gold = info.costnum
		ret = i18n("auction_text_09", 40)
	else
		_ENV = 40
		;(40).name = info.name2
		;(40).kid = info.kid2
		;(40).item = itemName
		;(40).gold = info.costnum
		ret = i18n("auction_text_08", 40)
	end
	return ret, color
end
return tradeBoardRecordsSingle
