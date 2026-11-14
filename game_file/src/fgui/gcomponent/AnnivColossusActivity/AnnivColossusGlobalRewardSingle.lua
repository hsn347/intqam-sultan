local baseComponent = require("fgui.base.baseComponent")
local annivColossusCtrl = SoraDGetCtrl("annivColossusCtrl")
local annivColossusRead = include("annivColossusRead")
_ENV = "annivColossusRead"
;("annivColossusRead").PERSON = 1
local ("annivColossusRead").GLOBAL, REWARDTYPE = 2, "annivColossusRead"
local AnnivColossusGlobalRewardSingle = fgui.extension_class(fgui.GComponent, baseComponent)
fgui.register_extension("ui://AnnivColossusActivity/AnnivColossusGlobalRewardSingle", AnnivColossusGlobalRewardSingle)
function AnnivColossusGlobalRewardSingle:onInit()
	self:fixChildrenPos()
	self.fields.scroll:setItemRenderer(handler(self, self.onNormalItemRenderer))
	self.fields.txt_got:setString(i18n("common_text_1892"))
	self.fields.txt_not:setString(i18n("build_colossus_11"))
	self.fields.txt_ing:setString(i18n("activity_text_05"))
	self.debug = true
end
function AnnivColossusGlobalRewardSingle:onShow()
end
function AnnivColossusGlobalRewardSingle:initData(rewardCfg)
	REWARDTYPE = nil
	;(nil)[1] = "id"
	;(nil)[2] = "count"
	self.rewards = serviceFunctions.tableFormat(rewardCfg.Reward, nil)
	self.fields.scroll:setNumItems(#self.rewards)
	local globalScore = annivColossusCtrl:getGlobalScore()
	local isGot = annivColossusCtrl:isRewardGot(REWARDTYPE.GLOBAL, rewardCfg.Rank)
	_ENV = nil
	;(nil).var = "" .. globalScore .. "/" .. rewardCfg.NeedNum
	self.fields.txt_progress:setString(i18n("build_colossus_06", nil))
	_ENV = i18n("build_colossus_06", nil)
	i18n("build_colossus_06", nil).var = rewardCfg.Rank
	self.fields.txt_step:setString(i18n("build_colossus_05", i18n("build_colossus_06", nil)))
	if isGot then
		self.fields.icon_got:setVisible(true)
		self.fields.txt_got:setVisible(true)
		self.fields.txt_not:setVisible(false)
		self.fields.txt_ing:setVisible(false)
	else
		self.fields.txt_got:setVisible(false)
		self.fields.icon_got:setVisible(false)
		local curRoundCfg = annivColossusRead:getCurGlobalRound(globalScore)
		self.fields.txt_ing:setVisible(curRoundCfg == rewardCfg)
		self.fields.txt_not:setVisible(curRoundCfg ~= rewardCfg)
	end
end
function AnnivColossusGlobalRewardSingle:onNormalItemRenderer(index, obj)
	local item = self.rewards[index + 1]
	obj:initData(item.id, item.count)
end
return AnnivColossusGlobalRewardSingle
