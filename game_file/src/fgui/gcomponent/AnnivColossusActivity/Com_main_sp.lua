local baseComponent = require("fgui.base.baseComponent")
local annivColossusCtrl = SoraDGetCtrl("annivColossusCtrl")
local annivColossusRead = include("annivColossusRead")
local activityShowCtrl = SoraDGetCtrl("activityShowCtrl")
local backpackCtrl = SoraDGetCtrl("backpackCtrl")
local publicRead = include("publicRead")
local jumpDesRead = include("jumpDesRead")
local itemDesRead = include("itemDesRead")
local Com_main_sp = fgui.extension_class(fgui.GComponent, baseComponent)
fgui.register_extension("ui://AnnivColossusActivity/Com_main_sp", Com_main_sp)
_ENV = fgui.register_extension
fgui.register_extension.PERSON = 1
local fgui.register_extension.GLOBAL, REWARDTYPE = 2, fgui.register_extension
function Com_main_sp:onInit()
	self.fields.Usm_2:setVisible(false)
	_ENV = false
	;(false).byUID = true
	local oldRank = SoraDConfigGet("Game:CaveExploreActivityPanel:oldRank~string", false)
	if oldRank then
		self.oldUrl = "frame_jx_dx" .. oldRank .. ".png"
	end
end
function Com_main_sp:onShow()
end
function Com_main_sp:updateMainSp(isFirst)
	self.fields.sp_main_show:setVisible(not isFirst)
	local globalScore = annivColossusCtrl:getGlobalScore()
	local curRoundCfg = annivColossusRead:getCurGlobalRound(globalScore)
	local curRank = curRoundCfg.Rank
	if globalScore >= annivColossusRead:getMaxScore(REWARDTYPE.GLOBAL) then
		curRank = 6
	end
	local url = "frame_jx_dx" .. curRank .. ".png"
	self.fields.sp_main_show:setURL(url)
	local isShowShunShine = true
	if curRank == 5 then
		self.fields.Usm_2:setEffectPath("G_bufenjin.usm", true)
		self.fields.Usm_2:setBlendFunc(gl.ONE, gl.ONE)
		self.fields.Usm_2:setPosition(230, 625)
		self.fields.Usm_2:play(true)
	elseif curRank == 6 then
		self.fields.Usm_2:setBlendFunc(gl.GL_SRC_ALPHA, gl.ONE)
		self.fields.Usm_2:setEffectPath("quanjin.usm", true)
		self.fields.Usm_2:play(true)
		self.fields.Usm_2:setScale(1.0, 0.99)
		self.fields.Usm_2:setPosition(221, 479)
	end
	if self.oldUrl and self.oldUrl ~= url then
		SoraDPlaySound("sixYear", "sfx_statue_upgrade")
		self.fields.sp_main_show2:setVisible(true)
		self.fields.sp_main_show2:setURL(self.oldUrl)
		self.fields.sp_main_show2:setAlpha(1)
		self.fields.sp_main_show:setAlpha(0)
		self.fields.Usm_1:setVisible(true)
		annivColossusRead = 479
		;(479)[1] = ffa.delay(0.35)
		;(479)[2] = ffa.fadeTo(0.15, 0)
		;(479)[3] = ffa.fadeTo(0.15, 0)
		;(479)[4] = ffa.fadeTo(0.15, 0)
		self.fields.sp_main_show2:runAction(ffa.seq(479))
		annivColossusRead = ffa.seq(479)
		ffa.seq(479)[1] = ffa.delay(0.35)
		ffa.seq(479)[2] = ffa.fadeTo(0.15, 1.0)
		ffa.seq(479)[3] = ffa.fadeTo(0.15, 1.0)
		ffa.seq(479)[4] = ffa.fadeTo(0.15, 1.0)
		self.fields.sp_main_show:runAction(ffa.seq(ffa.seq(479)))
		self.fields.Usm_1:play(false)
		self.fields.Usm_1:setBlendFunc(gl.ONE, gl.ONE)
		self.fields.Usm_1:setCompleteCallback(function()
			self.fields.Usm_1:setVisible(false)
		end)
	end
	self.fields.Usm_2:setVisible(curRank == 5 or curRank == 6)
	annivColossusCtrl = curRank
	curRank.byUID = true
	SoraDConfigSet("Game:CaveExploreActivityPanel:oldRank~string", "" .. curRank, curRank)
	self.oldUrl = url
	return isShowShunShine
end
return Com_main_sp
