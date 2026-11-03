-- CHM 101: General Chemistry I -- new questions
-- =============================================================================
-- 73 original questions on mass spectrometry, quantum theory, electronic
-- configuration, periodic trends, bonding and shapes, the mole concept and
-- stoichiometry, gas laws, thermochemistry, kinetics and acids/bases, based on the
-- topics in the supplied CHM 101 lecture materials and past questions. All stems
-- and numbers are original and every numeric answer is computed. No student
-- compiler's wording or name is used.
-- =============================================================================
-- This file ONLY ADDS. If a subject whose name starts with 'CHM 101' already
-- exists, the new questions join it (same id, name, faculty, level, semester and
-- units). Otherwise a new subject 'chm-101-general-chemistry-1' is created. A question whose text is
-- already in that subject is skipped, so running the file twice is safe.
with src (question, options, correct_index, explanation, topic) as (
values
  ('A mass spectrometer can be used for all of the following EXCEPT:', '["identifying the functional groups in a compound","detecting isotopes and measuring their relative abundance","measuring relative atomic and molecular masses","identifying unknown compounds from their fragmentation"]'::jsonb, 0, 'Functional groups are identified mainly by infrared spectroscopy; a mass spectrometer gives masses and abundances.', 'Mass Spectrometry'),
  ('In a mass spectrometer, the particles that are accelerated, deflected and detected must be:', '["uncharged","charged","free radicals","neutral molecules"]'::jsonb, 1, 'Only ions are affected by the electric and magnetic fields. Neutral atoms are first ionised.', 'Mass Spectrometry'),
  ('In a magnetic field, the lighter ions in a mass spectrometer are deflected:', '["less than the heavier ions","by the same amount as the heavier ions","more than the heavier ions","not at all"]'::jsonb, 2, 'For ions of the same charge, deflection is greater for smaller mass.', 'Mass Spectrometry'),
  ('In the mass spectrum of a compound, the peak with the highest mass-to-charge ratio normally corresponds to the:', '["base peak","lightest fragment","standard reference","molecular ion"]'::jsonb, 3, 'The molecular (parent) ion peak shows the relative molecular mass of the compound; the base peak is the most intense peak.', 'Mass Spectrometry'),
  ('The mass spectrum of neon shows three lines at mass numbers 20, 21 and 22. These atoms are called:', '["isotopes","isomers","isobars","isotones"]'::jsonb, 0, 'Atoms of the same element with different mass numbers are isotopes.', 'Mass Spectrometry'),
  ('Magnesium has isotopes of mass 24 (78.99%), 25 (10.00%) and 26 (11.01%). Its relative atomic mass is:', '["25.00","24.32","24.00","24.99"]'::jsonb, 1, 'Relative atomic mass $= \dfrac{24(78.99) + 25(10.00) + 26(11.01)}{100} = 24.32$.', 'Mass Spectrometry'),
  ('Chlorine consists of 75% chlorine-35 and 25% chlorine-37. Its relative atomic mass is:', '["36.0","35.0","35.5","36.5"]'::jsonb, 2, '$(35\times75 + 37\times25)/100 = 35.5$.', 'Mass Spectrometry'),
  ('An atom has twice as many protons as, and four more neutrons than, an atom of $^{9}\text{Be}$. Its symbol is:', '["$^{16}\\text{O}$","$^{18}\\text{Be}$","$^{14}\\text{N}$","$^{17}\\text{O}$"]'::jsonb, 3, 'Beryllium has 4 protons and 5 neutrons. The new atom has 8 protons (oxygen) and 9 neutrons, so mass number 17.', 'Atomic Structure'),
  ('The three isotopes of hydrogen differ in physical properties because they have different numbers of:', '["neutrons","protons","electrons","orbitals"]'::jsonb, 0, 'Isotopes have the same number of protons but different numbers of neutrons.', 'Atomic Structure'),
  ('Calculate the wavelength of an electron moving at $10^{5}\ \text{m/s}$ ($m = 9.11\times10^{-31}$ kg, $h = 6.63\times10^{-34}$ J s).', '["7.278 m","7.278 nm","0.7278 nm","72.78 nm"]'::jsonb, 1, 'de Broglie: $\lambda = \dfrac{h}{mv} = \dfrac{6.63\times10^{-34}}{9.11\times10^{-31}\times10^{5}} = 7.28\times10^{-9}\ \text{m} = 7.278\ \text{nm}$.', 'Wave-Particle Duality'),
  ('The energy of a photon of wavelength 500 nm is approximately ($h = 6.63\times10^{-34}$ J s, $c = 3.0\times10^{8}$ m/s):', '["3.98 × 10⁻²⁵ J","1.33 × 10⁻²⁷ J","3.98 × 10⁻¹⁹ J","6.63 × 10⁻³⁴ J"]'::jsonb, 2, '$E = hc/\lambda = \dfrac{6.63\times10^{-34}\times3.0\times10^{8}}{500\times10^{-9}} = 3.98\times10^{-19}$ J.', 'Quantum Theory'),
  ('The frequency of light of wavelength 600 nm is ($c = 3.0\times10^{8}$ m/s):', '["2.0 × 10⁻¹⁵ Hz","5.0 × 10⁶ Hz","1.8 × 10¹¹ Hz","5.0 × 10¹⁴ Hz"]'::jsonb, 3, '$\nu = c/\lambda = 3.0\times10^{8}/(600\times10^{-9}) = 5.0\times10^{14}$ Hz.', 'Quantum Theory'),
  ('The scientist who proposed the quantum theory of radiation is:', '["Max Planck","Albert Einstein","Niels Bohr","Erwin Schrödinger"]'::jsonb, 0, 'Planck proposed in 1900 that energy is emitted and absorbed in discrete quanta, $E = h\nu$.', 'Quantum Theory'),
  ('A perfect black body absorbs and emits radiation in:', '["continuous amounts of energy","discrete quanta of energy","only the visible region","no definite pattern at any temperature"]'::jsonb, 1, 'This quantisation was Planck''s key idea.', 'Quantum Theory'),
  ('In the photoelectric effect, increasing the intensity of light above the threshold frequency:', '["increases the maximum kinetic energy of each electron","causes a delay before electrons are ejected","increases the number of electrons ejected but not their maximum kinetic energy","stops the emission of electrons"]'::jsonb, 2, 'Energy per photon depends on frequency; intensity changes the number of photons.', 'Quantum Theory'),
  ('The ionisation energy of the hydrogen atom from the ground state is:', '["3.4 eV","1.6 eV","2.18 eV","13.6 eV"]'::jsonb, 3, 'The energy levels are $E_{n} = -13.6/n^{2}$ eV, so 13.6 eV is needed to remove the electron from $n = 1$.', 'Bohr Model'),
  ('The energy of the electron in the $n = 2$ level of hydrogen is:', '["-3.4 eV","-13.6 eV","-6.8 eV","-1.5 eV"]'::jsonb, 0, '$E_{2} = -13.6/2^{2} = -3.4$ eV.', 'Bohr Model'),
  ('The principle stating that it is impossible to determine simultaneously the exact position and momentum of an electron is:', '["Hund''s rule","Heisenberg''s uncertainty principle","Pauli''s exclusion principle","the aufbau principle"]'::jsonb, 1, 'This is the uncertainty principle: $\Delta x\,\Delta p \geq h/4\pi$.', 'Quantum Theory'),
  ('No two electrons in an atom can have the same set of four quantum numbers. This is:', '["Hund''s rule","Heisenberg''s principle","Pauli''s exclusion principle","Dalton''s law"]'::jsonb, 2, 'An orbital holds at most two electrons of opposite spin.', 'Electronic Configuration'),
  ('Electrons fill degenerate orbitals singly, with parallel spins, before pairing. This is:', '["Pauli''s principle","the aufbau principle","Bohr''s postulate","Hund''s rule"]'::jsonb, 3, 'It minimises electron-electron repulsion.', 'Electronic Configuration'),
  ('The maximum number of electrons in the shell with principal quantum number $n$ is:', '["$2n^{2}$","$n^{2}$","$2n$","$n + 2$"]'::jsonb, 0, 'Shell capacities are 2, 8, 18, 32, ...', 'Quantum Numbers'),
  ('The number of orbitals in a subshell with azimuthal quantum number $l$ is:', '["$l + 1$","$2l + 1$","$2l$","$l^{2}$"]'::jsonb, 1, 'For $l = 2$ (d subshell) there are 5 orbitals.', 'Quantum Numbers'),
  ('The number of orbitals in a d subshell is:', '["3","7","5","9"]'::jsonb, 2, '$2l + 1 = 5$ for $l = 2$.', 'Quantum Numbers'),
  ('For $n = 3$, the possible values of $l$ are:', '["1, 2 and 3","0, 1, 2 and 3","0 and 1 only","0, 1 and 2"]'::jsonb, 3, '$l$ runs from 0 to $n - 1$.', 'Quantum Numbers'),
  ('The electronic configuration of iron ($Z = 26$) is:', '["[Ar] 3d⁶ 4s²","[Ar] 3d⁸","[Ar] 3d⁵ 4s³","[Ar] 4s² 4p⁶"]'::jsonb, 0, 'After argon (18), two electrons go to 4s and six to 3d.', 'Electronic Configuration'),
  ('The ground-state configuration of copper ($Z = 29$) is:', '["[Ar] 3d⁹ 4s²","[Ar] 3d¹⁰ 4s¹","[Ar] 3d¹¹","[Ar] 4s² 4p⁹"]'::jsonb, 1, 'A completely filled d subshell is especially stable, so one 4s electron moves to 3d.', 'Electronic Configuration'),
  ('The shape of an s orbital is:', '["dumbbell-shaped","double dumbbell-shaped","spherical","planar"]'::jsonb, 2, 'p orbitals are dumbbell-shaped.', 'Atomic Orbitals'),
  ('Across a period from left to right, atomic radius generally:', '["increases","stays constant","first increases then decreases","decreases"]'::jsonb, 3, 'Nuclear charge rises while the electrons are added to the same shell, pulling them closer.', 'Periodic Trends'),
  ('Down a group, the first ionisation energy generally:', '["decreases","increases","stays constant","doubles at each period"]'::jsonb, 0, 'The outer electron is further from the nucleus and better shielded.', 'Periodic Trends'),
  ('The element with the highest electronegativity is:', '["oxygen","fluorine","chlorine","caesium"]'::jsonb, 1, 'Fluorine is the most electronegative element (4.0 on the Pauling scale).', 'Periodic Trends'),
  ('Which of these has the largest ionic radius?', '["$\\text{F}^{-}$","$\\text{Na}^{+}$","$\\text{O}^{2-}$","$\\text{Mg}^{2+}$"]'::jsonb, 2, 'These ions are isoelectronic (10 electrons); the one with the fewest protons is largest.', 'Periodic Trends'),
  ('The alkali metals become more reactive down the group because:', '["their atomic radius decreases","their ionisation energy increases","their nuclear charge decreases","their outer electron is lost more easily"]'::jsonb, 3, 'Larger atoms with greater shielding lose the outer electron more readily.', 'Periodic Trends'),
  ('The noble gases are chemically unreactive mainly because:', '["they have complete outer electron shells","they have high atomic masses","they are all gases","they have no electrons"]'::jsonb, 0, 'A full valence shell is very stable.', 'Periodic Table'),
  ('Elements in the same group of the periodic table have the same:', '["number of shells","number of valence electrons","atomic mass","number of neutrons"]'::jsonb, 1, 'The group number reflects the number of outer electrons (for main-group elements).', 'Periodic Table'),
  ('Transition metals typically show:', '["a single oxidation state and colourless compounds","no ability to form complexes","variable oxidation states and coloured compounds","low melting points"]'::jsonb, 2, 'Partly filled d orbitals allow several oxidation states and d–d transitions.', 'Transition Elements'),
  ('The shape of the methane molecule, $\text{CH}_{4}$, is:', '["trigonal planar","square planar","linear","tetrahedral"]'::jsonb, 3, 'Four bonding pairs and no lone pairs give a tetrahedral shape (bond angle 109.5°).', 'Bonding and Shapes'),
  ('The shape of the ammonia molecule, $\text{NH}_{3}$, is:', '["trigonal pyramidal","trigonal planar","tetrahedral","bent"]'::jsonb, 0, 'Three bonding pairs and one lone pair give a pyramidal shape.', 'Bonding and Shapes'),
  ('The shape of the water molecule is:', '["linear","bent (V-shaped)","trigonal pyramidal","tetrahedral"]'::jsonb, 1, 'Two bonding pairs and two lone pairs give a bent shape with an angle of about 104.5°.', 'Bonding and Shapes'),
  ('The shape of $\text{BF}_{3}$ is:', '["trigonal pyramidal","tetrahedral","trigonal planar","T-shaped"]'::jsonb, 2, 'Three bonding pairs and no lone pairs give bond angles of 120°.', 'Bonding and Shapes'),
  ('Carbon dioxide is a linear molecule, so its bond dipoles:', '["add up, making it polar","are absent","point in the same direction","cancel, making the molecule non-polar"]'::jsonb, 3, 'The two C=O bond dipoles are equal and opposite.', 'Bonding and Shapes'),
  ('The hybridisation of the carbon atom in ethene ($\text{C}_{2}\text{H}_{4}$) is:', '["sp²","sp³","sp","sp³d"]'::jsonb, 0, 'Each carbon forms three sigma bonds in a plane and one pi bond.', 'Hybridisation'),
  ('The bond order of the $\text{O}_{2}$ molecule is:', '["1","2","3","2.5"]'::jsonb, 1, 'Oxygen has a double bond (and two unpaired electrons, which is why it is paramagnetic).', 'Molecular Orbital Theory'),
  ('Hydrogen bonding is strongest when hydrogen is bonded to:', '["carbon","another hydrogen atom","a small, highly electronegative atom such as F, O or N","a noble gas"]'::jsonb, 2, 'This is why water has an unusually high boiling point.', 'Intermolecular Forces'),
  ('The type of bonding in sodium chloride is:', '["covalent","metallic","hydrogen bonding","ionic"]'::jsonb, 3, 'Sodium transfers an electron to chlorine, and the ions attract.', 'Chemical Bonding'),
  ('The molar mass of $\text{H}_{2}\text{SO}_{4}$ is ($\text{H} = 1$, $\text{S} = 32$, $\text{O} = 16$):', '["98 g/mol","96 g/mol","49 g/mol","114 g/mol"]'::jsonb, 0, '$2(1) + 32 + 4(16) = 98$.', 'Mole Concept'),
  ('The number of moles in 53 g of $\text{Na}_{2}\text{CO}_{3}$ ($M = 106$ g/mol) is:', '["0.25","0.50","1.00","2.00"]'::jsonb, 1, '$n = m/M = 53/106 = 0.50$ mol.', 'Mole Concept'),
  ('The number of molecules in 0.5 mol of a gas is ($N_{A} = 6.02\times10^{23}$):', '["6.02 × 10²³","1.20 × 10²⁴","3.01 × 10²³","3.01 × 10²⁴"]'::jsonb, 2, '$0.5\times6.02\times10^{23} = 3.01\times10^{23}$.', 'Mole Concept'),
  ('A compound contains 40% C, 6.7% H and 53.3% O by mass. Its empirical formula is:', '["CHO","C₂H₄O","CH₄O","CH₂O"]'::jsonb, 3, 'Moles: C $3.33$, H $6.7$, O $3.33$; dividing by 3.33 gives 1 : 2 : 1.', 'Empirical Formula'),
  ('The molarity of a solution containing 5.85 g of NaCl ($M = 58.5$) in 500 cm³ is:', '["0.20 mol/dm³","0.10 mol/dm³","0.50 mol/dm³","1.00 mol/dm³"]'::jsonb, 0, '$n = 0.10$ mol; $c = 0.10/0.5 = 0.20$ mol/dm³.', 'Solutions and Molarity'),
  ('What volume of 2.0 mol/dm³ solution is needed to prepare 500 cm³ of 0.4 mol/dm³ solution by dilution?', '["400 cm³","100 cm³","1000 cm³","50 cm³"]'::jsonb, 1, '$C_{1}V_{1} = C_{2}V_{2}$: $V_{1} = 0.4\times500/2.0 = 100$ cm³.', 'Solutions and Molarity'),
  ('In the reaction $2\text{H}_{2} + \text{O}_{2} \rightarrow 2\text{H}_{2}\text{O}$, the mass of water formed from 4 g of hydrogen (excess oxygen) is:', '["18 g","72 g","36 g","4 g"]'::jsonb, 2, '4 g of H₂ is 2 mol, which gives 2 mol of H₂O: $2\times18 = 36$ g.', 'Stoichiometry'),
  ('If a reaction has a theoretical yield of 25.0 g and an actual yield of 20.0 g, the percentage yield is:', '["125%","75%","20%","80%"]'::jsonb, 3, 'Percentage yield $= (20.0/25.0)\times100 = 80\%$.', 'Stoichiometry'),
  ('The limiting reagent in a reaction is the reactant that:', '["is completely used up first","is present in the largest amount","has the largest molar mass","is always a gas"]'::jsonb, 0, 'It determines the maximum amount of product.', 'Stoichiometry'),
  ('At standard temperature and pressure (0 °C and 1 atm), the volume of 1 mol of an ideal gas is:', '["24.0 dm³","22.4 dm³","1.0 dm³","11.2 dm³"]'::jsonb, 1, 'This molar volume follows from $PV = nRT$.', 'Gas Laws'),
  ('A gas sample of 1.0 mol at 300 K is held at a pressure of 2.0 atm. Its volume is ($R = 0.0821$ dm³ atm K⁻¹ mol⁻¹):', '["24.6 dm³","6.2 dm³","12.3 dm³","49.2 dm³"]'::jsonb, 2, '$V = nRT/P = (1)(0.0821)(300)/2.0 = 12.3$ dm³.', 'Gas Laws'),
  ('The heat needed to raise the temperature of 100 g of water from 25 °C to 75 °C is ($c = 4.18$ J g⁻¹ °C⁻¹):', '["4.18 kJ","41.8 kJ","10.45 kJ","20.90 kJ"]'::jsonb, 3, '$q = mc\Delta T = 100\times4.18\times50 = 20900$ J $= 20.90$ kJ.', 'Thermochemistry'),
  ('For an exothermic reaction, $\Delta H$ is:', '["negative","positive","zero","always equal to $\\Delta G$"]'::jsonb, 0, 'Heat is released to the surroundings, so the enthalpy of the system decreases.', 'Thermochemistry'),
  ('The standard enthalpy of formation of an element in its standard state is:', '["positive","zero","negative","equal to its ionisation energy"]'::jsonb, 1, 'By definition, the formation of an element from itself involves no change.', 'Thermochemistry'),
  ('Hess''s law states that the enthalpy change of a reaction:', '["depends on the speed of the reaction","depends on the catalyst used","is independent of the route taken","is always negative"]'::jsonb, 2, 'Enthalpy is a state function.', 'Thermochemistry'),
  ('Given $\Delta H_{f}$ (kJ/mol): $\text{CO}_{2}$ = -393.5, $\text{H}_{2}\text{O(l)}$ = -285.8, $\text{C}_{2}\text{H}_{2}$ = +226.7 and $\text{O}_{2}$ = 0, the enthalpy change for $\text{C}_{2}\text{H}_{2} + \tfrac{5}{2}\text{O}_{2} \rightarrow 2\text{CO}_{2} + \text{H}_{2}\text{O}$ is:', '["-1526.2 kJ","-565.5 kJ","+1299.5 kJ","-1299.5 kJ"]'::jsonb, 3, '$\Delta H = \sum\Delta H_{f}(\text{products}) - \sum\Delta H_{f}(\text{reactants}) = [2(-393.5) + (-285.8)] - 226.7 = -1299.5$ kJ.', 'Thermochemistry'),
  ('Which of the following does NOT increase the rate of a chemical reaction?', '["lowering the temperature","increasing the concentration of the reactants","adding a catalyst","increasing the surface area of a solid reactant"]'::jsonb, 0, 'Lower temperature reduces the number of molecules with enough energy to react.', 'Chemical Kinetics'),
  ('A catalyst increases the rate of a reaction by:', '["raising the temperature","providing a path of lower activation energy","increasing the enthalpy change","changing the equilibrium constant"]'::jsonb, 1, 'It is not consumed and does not change $\Delta H$.', 'Chemical Kinetics'),
  ('For a first-order reaction with rate constant $k = 0.0231\ \text{min}^{-1}$, the half-life is approximately:', '["3.3 min","0.016 min","30 min","60 min"]'::jsonb, 2, '$t_{1/2} = 0.693/k = 0.693/0.0231 = 30$ min.', 'Chemical Kinetics'),
  ('For the rate law $\text{rate} = k[\text{A}]^{2}[\text{B}]$, the overall order of the reaction is:', '["2","1","4","3"]'::jsonb, 3, 'The overall order is the sum of the exponents: $2 + 1 = 3$.', 'Chemical Kinetics'),
  ('If the concentration of A is doubled in a reaction that is second order in A, the rate:', '["increases four times","doubles","is unchanged","increases eight times"]'::jsonb, 0, 'Rate $\propto [\text{A}]^{2}$, so $2^{2} = 4$.', 'Chemical Kinetics'),
  ('The pH of a $0.01\ \text{mol/dm}^{3}$ solution of hydrochloric acid is:', '["1","2","12","0.01"]'::jsonb, 1, 'HCl is a strong acid: $\text{pH} = -\log(0.01) = 2$.', 'Acids and Bases'),
  ('The pH of a $0.001\ \text{mol/dm}^{3}$ solution of sodium hydroxide at 25 °C is:', '["3","10","11","1"]'::jsonb, 2, '$\text{pOH} = 3$, so $\text{pH} = 14 - 3 = 11$.', 'Acids and Bases'),
  ('At 25 °C the ionic product of water, $K_{w}$, is:', '["$1.0\\times10^{-7}$","$1.0\\times10^{14}$","$7.0$","$1.0\\times10^{-14}$"]'::jsonb, 3, '$[\text{H}^{+}][\text{OH}^{-}] = 10^{-14}$.', 'Acids and Bases'),
  ('Which of these is a strong acid?', '["nitric acid","ethanoic acid","carbonic acid","hydrogen cyanide"]'::jsonb, 0, 'Nitric acid ionises completely in water.', 'Acids and Bases'),
  ('A salt formed from a strong acid and a weak base gives an aqueous solution that is:', '["basic","acidic","neutral","a buffer"]'::jsonb, 1, 'The cation of the weak base hydrolyses and releases $\text{H}^{+}$.', 'Salts and Hydrolysis'),
  ('A buffer solution is one that:', '["has a pH of exactly 7","contains only a strong acid","resists changes in pH when small amounts of acid or base are added","is always neutral"]'::jsonb, 2, 'It contains a weak acid and its conjugate base (or a weak base and its conjugate acid).', 'Buffers'),
  ('In the Brønsted-Lowry theory, an acid is:', '["a proton acceptor","an electron-pair donor","a hydroxide donor","a proton donor"]'::jsonb, 3, 'A base is a proton acceptor.', 'Acids and Bases'),
  ('The conjugate base of $\text{H}_{2}\text{O}$ is:', '["$\\text{OH}^{-}$","$\\text{H}_{3}\\text{O}^{+}$","$\\text{H}_{2}$","$\\text{O}^{2-}$"]'::jsonb, 0, 'Removing a proton from water leaves hydroxide.', 'Acids and Bases')
),
tgt as (
  select subject_id, subject_name, faculty, department, level, semester, units
    from public.cbt_questions
   where subject_name ilike 'CHM 101%' and subject_id not like '%coming-soon'
   limit 1
)
insert into public.cbt_questions
  (subject_id, subject_name, institution, faculty, department, level,
   question, options, correct_index, explanation, topic, is_general, semester, units)
select coalesce(t.subject_id, 'chm-101-general-chemistry-1'),
       coalesce(t.subject_name, 'CHM 101: General Chemistry I'),
       'University of Nigeria, Nsukka',
       coalesce(t.faculty, 'Faculty of Physical Sciences, Faculty of Engineering, Faculty of Biological Sciences, Faculty of Veterinary Medicine, Faculty of Environmental Studies'),
       coalesce(t.department, 'Pure and Industrial Chemistry'),
       coalesce(t.level, '100 Level'),
       s.question, s.options, s.correct_index, s.explanation, s.topic, false,
       coalesce(t.semester, 'first'),
       coalesce(t.units, 2)
  from src s
  left join tgt t on true
 where not exists (
   select 1 from public.cbt_questions c
    where c.subject_id = coalesce(t.subject_id, 'chm-101-general-chemistry-1') and c.question = s.question);

select subject_id, subject_name, count(*) as questions
  from public.cbt_questions
 where subject_name ilike 'CHM 101%' and subject_id not like '%coming-soon'
 group by 1, 2;
