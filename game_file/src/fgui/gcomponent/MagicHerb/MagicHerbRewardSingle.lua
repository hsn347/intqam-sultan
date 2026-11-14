local magicHerbCtrl = SoraDGetCtrl("magicHerbCtrl")
local baseComponent = require("fgui.base.baseComponent")
local MagicHerbRewardSingle = fgui.extension_class(fgui.GComponent, baseComponent)
fgui.register_extension("ui://MagicHerb/MagicHerbRewardSingle", MagicHerbRewardSingle)
function MagicHerbRewardSingle:onInit()
	self:addClickListener(handler(self, self.onBtnClaim))
	self:fixChildrenPos()
	self.fields.n0:fix()
	self.fields.n1:fix()
end
function MagicHerbRewardSingle:onShow()
end
function MagicHerbRewardSingle:initData(cfg, parent)
	self.cfg = cfg
	self.parent = parent
	self.fields.title:setString(self.cfg.index)
	local isPay = magicHerbCtrl:isPayUnlock()
	local isSameA = magicHerbCtrl:isSameAlliance()
	if not isSameA then
		self.controllers.c1:setSelectedIndex(0)
	else
		self.controllers.c1:setSelectedIndex(isPay and 2 or 1)
	end
	if magicHerbCtrl:isFreeAwardGot(self.cfg.index) then
		self.controllers.c1:setSelectedIndex(0)
	end
	_UPVALUE2_ = 0
	;(0)[1] = "id"
	;(0)[2] = "count"
	local freeAward = serviceFunctions.tableFormat(self.cfg.freeaward, 0)
	_UPVALUE2_ = "id"
	;("id")[1] = "id"
	;("id")[2] = "count"
	local payAward = serviceFunctions.tableFormat(self.cfg.payaward, "id")
	for i = 1, 1 do
		self.fields["normal_reward_" .. i]:initData(freeAward[i].id, freeAward[i].count)
		if isSameA then
			local isShow = not magicHerbCtrl:isFreeAwardGot(self.cfg.index) and magicHerbCtrl:isCurPlanArrive(self.cfg.index)
			self.fields["normal_reward_" .. i]:setMovieBorder(isShow, cc.c3b(157, 197, 255))
			self.fields.Effect_1:setVisible(isShow)
			self.fields["done_normal_" .. i]:setVisible(magicHerbCtrl:isFreeAwardGot(self.cfg.index))
		else
			self.fields["normal_reward_" .. i]:setEffectShow(false)
			self.fields.Effect_1:setVisible(false)
			self.fields["done_normal_" .. i]:setVisible(false)
		end
	end
	for i = 1, 2 do
		self.fields["pay_reward_" .. i]:initData(payAward[i].id, payAward[i].count)
		if isSameA then
			local isShow = magicHerbCtrl:isPayUnlock() and not magicHerbCtrl:isFeeAwardGot(self.cfg.index) and magicHerbCtrl:isCurPlanArrive(self.cfg.index)
			self.fields["pay_reward_" .. i]:setMovieBorder(isShow, cc.c3b(255, 207, 157))
			self.fields.Effect_2:setVisible(isShow)
			self.fields["done_pay_" .. i]:setVisible(magicHerbCtrl:isFeeAwardGot(self.cfg.index) and magicHerbCtrl:isPayUnlock())
			self.fields["Icon_lock_" .. i]:setVisible(not magicHerbCtrl:isPayUnlock())
		else
			self.fields.Effect_2:setVisible(false)
			self.fields["pay_reward_" .. i]:setMovieBorder(false)
			self.fields["done_pay_" .. i]:setVisible(false)
			self.fields["Icon_lock_" .. i]:setVisible(true)
		end
	end
end
function MagicHerbRewardSingle:onBtnClaim()
	local isSameA = magicHerbCtrl:isSameAlliance()
	local isPay = magicHerbCtrl:isPayUnlock()
	local isShow = self.cfg.plan <= magicHerbCtrl:getCurPlan() and (not magicHerbCtrl:isFreeAwardGot(self.cfg.index) or isPay and not magicHerbCtrl:isFeeAwardGot(self.cfg.index))
	if isShow then
		if isSameA then
			SoraDShowLoading(self.parent:displayObject())
			magicHerbCtrl:sendGetReward(self.cfg.index)
		else
			SoraDShowMsgTip(i18n("magic_herb_text_008"))
		end
	end
end
return MagicHerbRewardSingle
