local lordInfoCtrl = SoraDGetCtrl("lordInfoCtrl")
local baseComponent = require("fgui.base.baseComponent")
local Com_inviteDetailItem = fgui.extension_class(fgui.GComponent, baseComponent)
fgui.register_extension("ui://newLordView/Com_inviteDetailItem", Com_inviteDetailItem)
function Com_inviteDetailItem:onInit()
	self.fields.Text_propTitle:fixPos()
	self.fields.Text_already:fixPos()
	self.fields.List:setItemRenderer(handler(self, self.onItemRederer))
	self.fields.Text_already:setAutoSize(fgui.AutoSizeType.SHRINK)
end
function Com_inviteDetailItem:onShow()
end
function Com_inviteDetailItem:onItemRederer(index, target)
	target:initData(self.itemList[index + 1].id, self.itemList[index + 1].num)
end
function Com_inviteDetailItem:initData(info, gType)
	if info and info.award then
		self.itemList = SoraDIntArr2FormatTable(info.award)
		self.fields.List:setNumItems(#self.itemList)
	end
	if gGameInviteType.PEOPLE == gType then
		_ENV = nil
		;(nil).num = info.num
		self.fields.Text_propTitle:setString(i18n("invite_text_11", nil))
	elseif gGameInviteType.PEOPLECASTLE == gType then
		_ENV = i18n("invite_text_11", nil)
		i18n("invite_text_11", nil).lv = info.num
		self.fields.Text_propTitle:setString(i18n("invite_text_03", i18n("invite_text_11", nil)))
		local limitTimes = info.limit
		local gotTimes = lordInfoCtrl:getFriendsCastleData(info.num)
		local NumStr = string.format("%d/%d", gotTimes, info.limit)
		local keyStr = i18n("reurn_text_08")
		local txtAlready = self.fields.Text_already
		local colorKey = "#FCDF90"
		if limitTimes <= gotTimes then
			colorKey = "#FF0000"
		end
		_ENV = i18n("invite_text_03", i18n("invite_text_11", nil))
		i18n("invite_text_03", i18n("invite_text_11", nil)).num = keyStr
		_ENV, _ENV, i18n("invite_text_03", i18n("invite_text_11", nil)).char = i18n("invite_text_03", i18n("invite_text_11", nil))
		_ENV, i18n("invite_text_03", i18n("invite_text_11", nil)).num, i18n("invite_text_03", i18n("invite_text_11", nil)).color = i18n("invite_text_03", i18n("invite_text_11", nil))
		i18n("invite_text_03", i18n("invite_text_11", nil)).char, i18n("invite_text_03", i18n("invite_text_11", nil)).color = i18n("invite_text_03", i18n("invite_text_11", nil))
		txtAlready:setString(i18n_html("common_text_1470", i18n("invite_text_03", i18n("invite_text_11", nil))))
		if SoraDFIsRA() then
			_ENV = i18n_html("common_text_1470", i18n("invite_text_03", i18n("invite_text_11", nil)))
			i18n_html("common_text_1470", i18n("invite_text_03", i18n("invite_text_11", nil))).num = NumStr
			_ENV, _ENV, i18n_html("common_text_1470", i18n("invite_text_03", i18n("invite_text_11", nil))).char = i18n_html("common_text_1470", i18n("invite_text_03", i18n("invite_text_11", nil)))
			_ENV, i18n_html("common_text_1470", i18n("invite_text_03", i18n("invite_text_11", nil))).num, i18n_html("common_text_1470", i18n("invite_text_03", i18n("invite_text_11", nil))).color = i18n_html("common_text_1470", i18n("invite_text_03", i18n("invite_text_11", nil)))
			i18n_html("common_text_1470", i18n("invite_text_03", i18n("invite_text_11", nil))).char, i18n_html("common_text_1470", i18n("invite_text_03", i18n("invite_text_11", nil))).color = i18n_html("common_text_1470", i18n("invite_text_03", i18n("invite_text_11", nil)))
			txtAlready:setString(i18n_html("common_text_1470", i18n_html("common_text_1470", i18n("invite_text_03", i18n("invite_text_11", nil)))))
		end
	end
end
return Com_inviteDetailItem
