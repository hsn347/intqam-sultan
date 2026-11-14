local baseComponent = require("fgui.base.baseComponent")
local Com_9001606_rule = fgui.extension_class(fgui.GComponent, baseComponent)
local activity_9001606_Read = include("activity_9001606_Read")
fgui.register_extension("ui://Activity_9001606/Com_9001606_rule", Com_9001606_rule)
function Com_9001606_rule:onInit()
	_UPVALUE3_ = nil
	;(nil)[1] = i18n("CombineServers_2")
	;(nil)[2] = i18n("CombineServers_3")
	;(nil)[3] = i18n("CombineServers_4")
	;(nil)[4] = i18n("CombineServers_5")
	;(nil)[5] = i18n("CombineServers_5")
	;(nil)[6] = i18n("CombineServers_5")
	;(nil)[7] = i18n("CombineServers_5")
	;(nil)[8] = i18n("CombineServers_5")
	;(nil)[9] = i18n("CombineServers_5")
	;(nil)[10] = i18n("CombineServers_5")
	;(nil)[11] = i18n("CombineServers_5")
	;(nil)[12] = i18n("CombineServers_5")
	;(nil)[13] = i18n("CombineServers_5")
	;(nil)[14] = i18n("CombineServers_5")
	;(nil)[15] = i18n("CombineServers_5")
	local (nil)[16], titles = i18n("CombineServers_5")
	local ruleCfg = activity_9001606_Read.getRuleCfg()
	for i = 1, 4 do
		local cfgs = ruleCfg[i]
		local _ENV, descTable = i18n("CombineServers_5")
		for _, v in ipairs(cfgs) do
			table.insert(descTable, v.name ~= "" and i18n(v.name) or " ")
		end
		self.fields["title" .. i]:initData(titles[i], i, handler(self, self.onSelected))
		self.fields["txt_msg" .. i]:setString(table.concat(descTable, "\n"))
	end
	self:onSelected(true, 1)
end
function Com_9001606_rule:onShow()
end
function Com_9001606_rule:onSelected(isSelected, clickIndex)
	self.curIndex = isSelected and clickIndex or -1
	for i = 1, 4 do
		self.fields["title" .. i]:setIsSelected(self.curIndex == i)
		self.fields["txt_msg" .. i]:setVisible(self.curIndex == i)
	end
	self.fields.layout:ensureBoundsCorrect()
	dump(self:getScrollPane(), "self:getScrollPane()")
end
return Com_9001606_rule
