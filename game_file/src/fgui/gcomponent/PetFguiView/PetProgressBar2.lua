local baseComponent = require("fgui.base.baseComponent")
local PetProgressBar2 = fgui.extension_class(fgui.GProgressBar, baseComponent)
fgui.register_extension("ui://PetFguiView/PetProgressBar2", PetProgressBar2)
fgui.register_extension("ui://PetFguiView/PetProgressBar3", PetProgressBar2)
local backpackltCtrl = gModuleMgr.sharedMgr("backpackltCtrl")
local petDesRead = include("petDesRead")
function PetProgressBar2:onInit()
	if not SoraDFIsRA() then
		self:fixChildrenPos(true, true)
		if self.fields.arrow_1 then
			self.fields.arrow_1:setScaleX(-1)
		end
	end
	self.fields.btn_detail:addClickEventListener(handler(self, self.showTip))
end
function PetProgressBar2:onShow()
end
function PetProgressBar2:initData(petData)
	_ENV = nil
	;(nil).lv = petData.level
	self.fields.text_cur_lv:setString(i18n("common_text_100", nil))
	local maxValue = petData.nextLevelExp
	local curValue = petData.curLevelExp
	if maxValue <= curValue then
		self:setValue(100)
		self.fields.Text_progress:setString("MAX")
		self:setValue(100)
	else
		self:setValue(curValue / maxValue * 100)
		self.fields.Text_progress:setString("" .. curValue .. "/" .. maxValue)
	end
	self.fields.barPreview:setVisible(false)
	self.maxValue = maxValue
	self.curValue = curValue
	self.fields.txt_add_exp:setString("")
end
function PetProgressBar2:setPreviewValue(data, lv, deltaExp, isOverLv)
	self.fields.barPreview:setVisible(true)
	self.fields.barPreview:setValue(data.curValue / data.maxValue * 100)
	if isOverLv then
		self:setValue(0)
	else
		self:setValue(self.curValue / self.maxValue * 100)
	end
	self.fields.Text_progress:setString("" .. data.curValue .. "/" .. data.maxValue)
	self.fields.text_cur_lv:setString(lv)
	self.fields.txt_add_exp:setString(deltaExp)
end
function PetProgressBar2:initDataUpStage(petData)
	local curRank = petData.rank
	local nextRank = curRank + 1
	self.fields.icon_cur_step:setURL(petDesRead.getRankIcon(curRank))
	self.fields.icon_next_step:setURL(petDesRead.getRankIcon(nextRank))
	local singleExp = backpackltCtrl:getPetAdvancedEXP(502801)
	local maxValueCoin = petData.nextRankExp / singleExp
	local curValueCoin = petData.curRankExp / singleExp
	self:setValue(curValueCoin / maxValueCoin * 100)
	self.fields.Text_progress:setString("" .. curValueCoin .. "/" .. maxValueCoin)
end
function PetProgressBar2:showTip()
	SoraDPlaySound()
	SoraDShowMsgTip(i18n("Dear_pet_mainTips1"))
end
return PetProgressBar2
