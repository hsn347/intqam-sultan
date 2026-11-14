local heroNewTrialCtrl = SoraDGetCtrl("heroNewTrialCtrl")
local baseComponent = require("fgui.base.baseComponent")
local Com_aniNpc = fgui.extension_class(fgui.GComponent, baseComponent)
fgui.register_extension("ui://HeroNewTrial/Com_aniNpc", Com_aniNpc)
function Com_aniNpc:onInit()
	_UPVALUE10_ = nil
	self.heros, (nil)[1] = nil, 1747
	self.heros, (nil)[2] = nil, 1748
	self.heros, (nil)[3] = nil, 1749
	self.heros, (nil)[4] = nil, 1750
	self.heros, (nil)[5] = nil, 1752
	self.heros, (nil)[6] = nil, 1753
	self.heros, (nil)[7] = nil, 1754
	self.heros, (nil)[8] = nil, 1755
	self.heros, (nil)[9] = nil, 1756
	self.heros, (nil)[10] = nil, 1757
	self.fields.mv_1747:setAllFrameName("3Sbubing_yd_n_%.2d.png", 1)
	self.fields.mv_1748:setAllFrameName("3sgb_yd_n_%.2d.png", 1)
	self.fields.mv_1749:setAllFrameName("yingxionghs_sj_n_%.2d.png", 1)
	self.fields.mv_1750:setAllFrameName("3sgb_yd_n_%.2d.png", 1)
	self.fields.mv_1752:setAllFrameName("yingxionghs_sj_n_%.2d.png", 1)
	self.fields.mv_1753:setAllFrameName("xfheroy02_yd_n_%.2d.png", 1)
	self.fields.mv_1754:setAllFrameName("yingxionghs_sj_n_%.2d.png", 1)
	self.fields.mv_1755:setAllFrameName("3sgb_yd_n_%.2d.png", 1)
	self.fields.mv_1756:setAllFrameName("yingxionghs_sj_n_%.2d.png", 1)
	self.fields.mv_1757:setAllFrameName("3sgb_yd_n_%.2d.png", 1)
	heroNewTrialCtrl, _ENV = self.fields.mv_1757, self.fields.mv_1757.setAllFrameName
	_UPVALUE2_, self.fields.mv_1757.setAllFrameName[1], self.fields.mv_1757[1] = self.fields.mv_1757, self.fields.mv_1757, 50
	_UPVALUE3_, self.fields.mv_1757.setAllFrameName[2], self.fields.mv_1757[1] = self.fields.mv_1757, self.fields.mv_1757, 20
	_UPVALUE3_, self.fields.mv_1757.setAllFrameName[2], self.fields.mv_1757[2] = self.fields.mv_1757, self.fields.mv_1757, 80
	self.showHero, _ENV, self._colX, self.fields.mv_1757.setAllFrameName[3], self.fields.mv_1757[1] = self.fields.mv_1757.setAllFrameName, self.fields.mv_1757.setAllFrameName, self.fields.mv_1757.setAllFrameName, self.fields.mv_1757, -10
	self.showHero, _ENV, self._colX, self.fields.mv_1757.setAllFrameName[3], self.fields.mv_1757[2] = self.fields.mv_1757.setAllFrameName, self.fields.mv_1757.setAllFrameName, self.fields.mv_1757.setAllFrameName, self.fields.mv_1757, 50
	self.showHero, _ENV, self._colX, self.fields.mv_1757.setAllFrameName[3], self.fields.mv_1757[3] = self.fields.mv_1757.setAllFrameName, self.fields.mv_1757.setAllFrameName, self.fields.mv_1757.setAllFrameName, self.fields.mv_1757, 110
	for k, v in ipairs(self.heros) do
		if heroNewTrialCtrl:unlockTrialAfk(v) then
			table.insert(self.showHero, v)
			self.fields["mv_" .. v]:setVisible(true)
		else
			self.fields["mv_" .. v]:setVisible(false)
		end
	end
end
function Com_aniNpc:_getRowHeroCounts(heroCount)
	if heroCount <= 0 then
		_ENV = nil
		return nil
	end
	if heroCount == 1 then
		_UPVALUE1_ = nil
		;(nil)[1] = 1
		return nil
	end
	_UPVALUE1_ = nil
	local (nil)[1], rowCounts = 2, nil
	local remain = heroCount - 2
	while 0 < remain do
		local rowNum = 3 <= remain and 3 or remain
		table.insert(rowCounts, rowNum)
		remain = remain - rowNum
	end
	return rowCounts
end
function Com_aniNpc:_buildHeroPosList(heroCount)
	local _ENV, posList
	local rowCounts = self:_getRowHeroCounts(heroCount)
	for rowIndex, colCount in ipairs(rowCounts) do
		local y = 70 * (rowIndex - 1) + 50
		local xs = self._colX[colCount]
		for _, x in ipairs(xs) do
			table.insert(posList, x)
			table.insert(posList, y)
		end
	end
	return posList
end
function Com_aniNpc:onShow()
	if #self.showHero > 0 then
		_UPVALUE2_ = self
		self[1] = "x"
		self[2] = "y"
		local posCfg = serviceFunctions.tableFormat(self:_buildHeroPosList(#self.showHero), self)
		for k, v in ipairs(self.showHero) do
			self.fields["mv_" .. v]:setPosition(posCfg[k].x, posCfg[k].y)
		end
	end
end
function Com_aniNpc:loopNpc(isLoop, time)
	if isLoop then
		for k, v in ipairs(self.showHero) do
			self.fields["mv_" .. v]:setAlpha(0)
			_UPVALUE2_ = nil
			;(nil)[1] = ffa.fadeIn(5)
			;(nil)[2] = ffa.delay(time - 8)
			;(nil)[3] = ffa.fadeOut(3)
			;(nil)[4] = ffa.fadeOut(3)
			self.fields["mv_" .. v]:runAction(ffa.seq(nil))
		end
	else
		for k, v in ipairs(self.showHero) do
			self.fields["mv_" .. v]:stopAllActions()
		end
	end
end
return Com_aniNpc
