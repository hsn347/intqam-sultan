local itemDesRead = include("itemDesRead")
local baseComponent = require("fgui.base.baseComponent")
local Label_LogItem = fgui.extension_class(fgui.GLabel, baseComponent)
fgui.register_extension("ui://AllianceShopView/Label_LogItem", Label_LogItem)
function Label_LogItem:onInit()
	self:fixChildrenPos()
end
function Label_LogItem:onShow()
end
function Label_LogItem:initData(v, curType)
	local singleLabel = curType == gAllianceStoreRecordType.STORE and "common_text_1953" or "common_text_1960"
	self.fields.Text_Time:setString(SoraDConverSecondToDate(math.max(serviceFunctions.systemTime() - v.time, 0), false, true))
	if v.score then
		if v.system then
			_ENV = SoraDConverSecondToDate(math.max(serviceFunctions.systemTime() - v.time, 0), false, true)
			SoraDConverSecondToDate(math.max(serviceFunctions.systemTime() - v.time, 0), false, true).var1 = itemDesRead.getName(v.id)
			SoraDConverSecondToDate(math.max(serviceFunctions.systemTime() - v.time, 0), false, true).var2 = v.count
			self.fields.Text_Des:setString(i18n("allianceShop_autoReturn_desc", SoraDConverSecondToDate(math.max(serviceFunctions.systemTime() - v.time, 0), false, true)))
		else
			_ENV = i18n("allianceShop_autoReturn_desc", SoraDConverSecondToDate(math.max(serviceFunctions.systemTime() - v.time, 0), false, true))
			i18n("allianceShop_autoReturn_desc", SoraDConverSecondToDate(math.max(serviceFunctions.systemTime() - v.time, 0), false, true)).var1 = v.name
			i18n("allianceShop_autoReturn_desc", SoraDConverSecondToDate(math.max(serviceFunctions.systemTime() - v.time, 0), false, true)).var2 = itemDesRead.getName(v.id)
			i18n("allianceShop_autoReturn_desc", SoraDConverSecondToDate(math.max(serviceFunctions.systemTime() - v.time, 0), false, true)).var3 = v.count
			self.fields.Text_Des:setString(i18n("alliance_store_returns_description_4", i18n("allianceShop_autoReturn_desc", SoraDConverSecondToDate(math.max(serviceFunctions.systemTime() - v.time, 0), false, true))))
		end
	else
		_ENV = i18n("alliance_store_returns_description_4", i18n("allianceShop_autoReturn_desc", SoraDConverSecondToDate(math.max(serviceFunctions.systemTime() - v.time, 0), false, true)))
		i18n("alliance_store_returns_description_4", i18n("allianceShop_autoReturn_desc", SoraDConverSecondToDate(math.max(serviceFunctions.systemTime() - v.time, 0), false, true))).name = v.name
		i18n("alliance_store_returns_description_4", i18n("allianceShop_autoReturn_desc", SoraDConverSecondToDate(math.max(serviceFunctions.systemTime() - v.time, 0), false, true))).item = itemDesRead.getName(v.id)
		i18n("alliance_store_returns_description_4", i18n("allianceShop_autoReturn_desc", SoraDConverSecondToDate(math.max(serviceFunctions.systemTime() - v.time, 0), false, true))).count = v.count
		self.fields.Text_Des:setString(i18n(singleLabel, i18n("alliance_store_returns_description_4", i18n("allianceShop_autoReturn_desc", SoraDConverSecondToDate(math.max(serviceFunctions.systemTime() - v.time, 0), false, true)))))
	end
end
return Label_LogItem
