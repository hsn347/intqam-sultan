local heroCtrl = SoraDGetCtrl("heroCtrl")
local heroPowerSkillGiftCtrl = SoraDGetCtrl("heroPowerSkillGiftCtrl")
_ENV = "heroPowerSkillGiftCtrl"
;("heroPowerSkillGiftCtrl").unreach = 0
;("heroPowerSkillGiftCtrl").reach = 1
;("heroPowerSkillGiftCtrl").buy = 2
local ("heroPowerSkillGiftCtrl").done, STATUS = 3, "heroPowerSkillGiftCtrl"
local baseComponent = require("fgui.base.baseComponent")
local Com_stageSingle = fgui.extension_class(fgui.GComponent, baseComponent)
fgui.register_extension("ui://NewHeroView/Com_stageSingle", Com_stageSingle)
function Com_stageSingle:onInit()
	self.fields.Text_done:setString(i18n("common_text_1892"))
	self.fields.Text_tip:setString(i18n("common_text_4825"))
	self.fields.Text_dis:setString(i18n("common_text_4826"))
	self.fields.List_reward:setItemRenderer(handler(self, self.onItemRederer))
	self.fields.Btn_claim:setString(i18n("common_text_1146"))
	self.fields.Btn_claim:addClickListener(handler(self, self.btnClaimClick))
	self.fields.Btn_buy:setString(i18n("common_text_4817"))
	self.fields.Btn_buy:addClickListener(handler(self, self.btnBuyClick))
	self.fields.timer:setTimeEndListener(handler(self, self.timeOut))
	self:fixChildrenPos()
end
function Com_stageSingle:onItemRederer(index, obj)
	obj:initData(self.reward[index + 1].id, self.reward[index + 1].count)
end
function Com_stageSingle:onShow()
end
function Com_stageSingle:timeOut()
	self:initData(self.cfg, self.heroID)
end
function Com_stageSingle:initData(cfg, heroID)
	self.cfg = cfg
	self.heroID = heroID
	_ENV = nil
	;(nil).pro = self.cfg.awakeStage
	self.fields.Text_pro:setString(i18n("%{pro}%", nil))
	self.reward = self.cfg.normalReward
	self.fields.List_reward:setNumItems(#self.reward)
	local value = heroCtrl:getHeroPowerSkillPercent(self.heroID)
	local status = STATUS.unreach
	if value >= self.cfg.awakeStage then
		local isClaimed = heroPowerSkillGiftCtrl:isCliamReward(self.heroID, self.cfg.stageID)
		local ret, count, leftTime = heroPowerSkillGiftCtrl:getGiftBuyTimes(self.cfg.specialGifts)
		if isClaimed then
			status = ret and STATUS.buy or STATUS.done
			if status == STATUS.buy and 0 < leftTime then
				self.fields.timer:beginTime(leftTime)
			end
		else
			status = STATUS.reach
		end
	end
	self.controllers.c1:setSelectedIndex(status)
end
function Com_stageSingle:btnClaimClick()
	SoraDPlaySound()
	heroPowerSkillGiftCtrl:reqCliamGift(self.heroID, self.cfg.stageID)
end
function Com_stageSingle:btnBuyClick()
	SoraDPlaySound()
	_ENV = nil
	;(nil).rid = self.cfg.specialGifts
	uiManager:show("HeroStageGift", nil)
end
return Com_stageSingle
