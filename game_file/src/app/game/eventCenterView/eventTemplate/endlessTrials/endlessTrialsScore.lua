local endlessTrialsCtrl = SoraDGetCtrl("endlessTrialsCtrl")
local endlessTrialsScore = class("endlessTrialsScore", function(target)
	if target == nil then
		return SoraDCreateTouchPanel("endlessTrialsScore")
	end
	return target
end)
function endlessTrialsScore:ctor()
	self:initWidget()
end
function endlessTrialsScore:initWidget()
	SoraDGetAllChildFromWidget(self, self)
	self.scaleActTarget = SoraDGetChildByName(self, "Center_Node")
	self.ccs_bg = SoraDGetExtendChildFromCCSByName(self, "CCS_commonPopBox_bg")
	self.ccs_bg:setTitleName(i18n("Endless_trial_text_11"))
	self.scroll = SoraDGetChildByName(self, "ScrollView_content")
	self.scroll = SoraDCreatePanelByCloneNode(self.scroll, "commonAutoScrollList")
	self.scroll:setSingleCreate(handler(self, self.createSingle))
	_UPVALUE2_ = self.scroll.setSingleCreate
	self.scroll.setSingleCreate[1] = i18n("Endless_trial_text_12")
	self.scroll.setSingleCreate[2] = i18n("common_text_2195")
	self.scroll.setSingleCreate[3] = i18n("common_text_032")
	self.scroll.setSingleCreate[4] = i18n("common_text_032")
	self.scroll.setSingleCreate[5] = i18n("common_text_032")
	self.scroll.setSingleCreate[6] = i18n("common_text_032")
	self.scroll.setSingleCreate[7] = i18n("common_text_032")
	local self.scroll.setSingleCreate[8], titleList = i18n("common_text_032")
	if SoraDFIsRA() then
		titleList = table.reverse(titleList)
	end
	_UPVALUE3_ = titleList
	titleList[1] = self.Text_title1
	titleList[2] = self.Text_title2
	titleList[3] = self.Text_title3
	for i, v in ipairs(titleList) do
		v:setString(titleList[i])
	end
	local effect = SoraDCreatAnimation("Node_Effect_wjtzjf01")
	SoraDMixtureGLONEByParent(effect)
	effect:addTo(self.scaleActTarget)
	effect:setPosition(0, -153)
end
function endlessTrialsScore:initData(mType)
	local bossTypeList = endlessTrialsCtrl:getBossTypeList(mType)
	self.Text_name:setString(i18n(worldMapDefine.getWorldBossName(bossTypeList[1])))
	local config = endlessTrialsCtrl:getScoreConfig(mType)
	self.scroll:updateScrollView(cc.size(530, 45), table.reverse(config))
end
function endlessTrialsScore:createSingle()
	local ocx = self.Node_single:clone()
	SoraDGetAllChildFromWidget(ocx, ocx)
	function ocx.initData(target, data, otherData)
		_UPVALUE3_ = nil
		;(nil)[1] = data.lv
		;(nil)[2] = data.perScore
		local (nil)[3], valueList = data.allienceScore, nil
		if SoraDFIsRA() then
			valueList = table.reverse(valueList)
		end
		_UPVALUE3_ = valueList
		valueList[1] = ocx.Text_value1
		valueList[2] = ocx.Text_value2
		valueList[3] = ocx.Text_value3
		for i, v in ipairs(valueList) do
			v:setString(tostring(valueList[i]))
		end
	end
	return ocx
end
return endlessTrialsScore
