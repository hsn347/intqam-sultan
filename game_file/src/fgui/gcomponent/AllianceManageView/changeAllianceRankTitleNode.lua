local allianceSetting = SoraDGetCtrl("allianceSetting")
local baseComponent = require("fgui.base.baseComponent")
local changeAllianceRankTitleNode = fgui.extension_class(fgui.GComponent, baseComponent)
fgui.register_extension("ui://AllianceManageView/changeAllianceRankTitleNode", changeAllianceRankTitleNode)
function changeAllianceRankTitleNode:onInit()
	_ENV = nil
	;(nil)[1] = gAllianceRank.R5
	;(nil)[2] = gAllianceRank.OFFICIAL
	;(nil)[3] = gAllianceRank.R4
	;(nil)[4] = gAllianceRank.R3
	;(nil)[5] = gAllianceRank.R2
	self.tableRankErr, _ENV, self.rankArray, (nil)[6] = nil, nil, nil, gAllianceRank.R1
	self.fields.Text_new:setString(i18n("common_text_257"))
	self.fields.Text_old:setString(i18n("common_text_256"))
	self.fields.Text_notice:setString(i18n("common_text_258"))
	self.fields.Button_change:setString(i18n("common_text_243"))
	self.fields.Button_change:setEnabled(false)
	self.fields.Button_change:addClickListener(handler(self, self.btnClickCallBack))
	self.fields.List:setItemRenderer(handler(self, self.onItemRenderer))
	self.fields.Text_new:fixPos()
	self.fields.Text_old:fixPos()
end
function changeAllianceRankTitleNode:onShow()
end
function changeAllianceRankTitleNode:registerEvent()
	SoraDAddMessage(self, "MESSAGE_ALLIACNE_SETTINGS_SUCCESS", handler(self, self.updateData))
end
function changeAllianceRankTitleNode:onItemRenderer(index, obj)
	obj:initData(self.rankArray[index + 1], handler(self, self.updateBtnType))
end
function changeAllianceRankTitleNode:updateBtnType(rankID, isCanTouch)
	self.tableRankErr[rankID] = isCanTouch
	local isEnable = true
	for i, v in pairs(self.tableRankErr) do
		if v == false then
			isEnable = false
		end
	end
	self.fields.Button_change:setEnabled(isEnable)
end
function changeAllianceRankTitleNode:updateData()
	print("updateData============")
	self.tableRankErr, _ENV = print, print
	self.fields.Button_change:setEnabled(false)
	self.fields.List:setNumItems(#self.rankArray)
end
function changeAllianceRankTitleNode:initData()
	self.fields.List:setNumItems(#self.rankArray)
end
function changeAllianceRankTitleNode:btnClickCallBack()
	SoraDPlaySound()
	local _ENV, rankNameList = SoraDPlaySound, SoraDPlaySound
	for i, v in ipairs(self.rankArray) do
		local single = self.fields.List:getChildAt(i - 1)
		local newTitle = single:getRankTitle()
		if newTitle then
			rankNameList["r" .. v .. "Name"] = newTitle
		end
	end
	allianceSetting:reqModifyRankName(rankNameList)
	self.fields.Button_change:setEnabled(false)
end
return changeAllianceRankTitleNode
