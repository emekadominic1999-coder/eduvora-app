// CHM 101 (General Chemistry I) - original questions on topics tested in the Unit 1-6 continuous assessment:
// stoichiometry and the mole concept, atomic structure, electronic configuration, periodicity, bonding, hydrogen, transition elements.
const L = require('../sta/lib');
const { add, out } = L;
const chk = (a, b, tol = 0.01) => { if (Math.abs(a - b) > tol) throw new Error('check failed ' + a + ' vs ' + b); };
const T = {
  aam: 'Average Atomic Mass', emp: 'Empirical and Molecular Formula', gas: 'Gas Stoichiometry', mol: 'Concentration of Stock Solutions',
  sol: 'Solution Stoichiometry', mil: 'Millikan Oil Drop Experiment', ruth: "Rutherford's Experiment", bohr: 'Bohr Model Calculations',
  conf: 'Electron Configuration', mo: 'Molecular Orbital Theory', per: 'Periodic Trends', ion: 'Ionization Energy Anomalies', iso: 'Isoelectronic Species',
  bond: 'Chemical Bonding', hyd: 'Hydrogen', tm: 'Transition Elements', alloy: 'Iron Alloys', pe: 'Photoelectric Effect',
};

// ---------------- average atomic mass
{ const v = (35 * 75.4 + 37 * 24.6) / 100; chk(v, 35.49);
  add('Chlorine occurs as 35Cl (75.4%) and 37Cl (24.6%). Calculate its average atomic mass.', '35.49', ['35.00', '36.00', '36.46'],
    'Step 1: Average atomic mass = (35 x 75.4 + 37 x 24.6) / 100.\nStep 2: = (2639.0 + 910.2) / 100 = 3549.2 / 100 = 35.49.\nShortcut: start from 35 and add 2 x 0.246 = 0.49, giving 35.49.', T.aam); }
{ const v = (63 * 69.2 + 65 * 30.8) / 100; chk(v, 63.62);
  add('Copper has two isotopes: 63Cu (69.2%) and 65Cu (30.8%). What is the average atomic mass of copper?', '63.62', ['64.00', '63.00', '64.62'],
    'Step 1: (63 x 69.2 + 65 x 30.8) / 100.\nStep 2: = (4359.6 + 2002.0) / 100 = 63.62.\nShortcut: 63 + 2 x 0.308 = 63.62.', T.aam); }
{ const v = (10 * 19.9 + 11 * 80.1) / 100; chk(v, 10.80);
  add('Boron has two isotopes: 10B (19.9%) and 11B (80.1%). Find the average atomic mass of boron.', '10.80', ['10.50', '11.00', '10.20'],
    'Step 1: (10 x 19.9 + 11 x 80.1) / 100 = (199 + 881.1) / 100.\nStep 2: = 10.80.\nShortcut: 10 + 1 x 0.801 = 10.80.', T.aam); }
{ const v = (24 * 78.99 + 25 * 10.00 + 26 * 11.01) / 100; chk(v, 24.32);
  add('Magnesium has three isotopes: 24Mg (78.99%), 25Mg (10.00%) and 26Mg (11.01%). Calculate the average atomic mass.', '24.32', ['25.00', '24.00', '24.99'],
    'Step 1: (24 x 78.99 + 25 x 10.00 + 26 x 11.01) / 100.\nStep 2: = (1895.76 + 250.00 + 286.26) / 100 = 24.32.\nShortcut: 24 + 0.10 + 2 x 0.1101 = 24.32.', T.aam); }
add('An element has two isotopes with masses 79 and 81 and an average atomic mass of 79.9. What are the percentage abundances of the isotopes?', '55% of mass 79 and 45% of mass 81', ['45% of mass 79 and 55% of mass 81', '50% of each isotope', '60% of mass 79 and 40% of mass 81'],
  'Step 1: Let x be the fraction of the mass-79 isotope. Then 79x + 81(1 - x) = 79.9.\nStep 2: 81 - 2x = 79.9, so x = 0.55.\nStep 3: The isotopes are 55% and 45%.\nShortcut: 79.9 is 0.9 above 79 and 1.1 below 81, so the lighter isotope is 1.1/2 = 55%.', T.aam);

// ---------------- empirical and molecular formula
add('A liquid contains 94.12% oxygen and 5.88% hydrogen by mass (H = 1.00, O = 16.00). What is its empirical formula?', 'HO', ['H2O', 'H2O2', 'HO2'],
  'Step 1: Moles of O = 94.12 / 16 = 5.88; moles of H = 5.88 / 1 = 5.88.\nStep 2: Ratio O : H = 1 : 1, so the empirical formula is HO.\nNote: with a molar mass of 34 g/mol the molecular formula would be H2O2.', T.emp);
add('A compound contains 40.0% carbon, 6.7% hydrogen and 53.3% oxygen by mass. What is its empirical formula? (C = 12, H = 1, O = 16)', 'CH2O', ['CHO', 'C2H4O', 'CH4O'],
  'Step 1: Moles: C = 40.0/12 = 3.33; H = 6.7/1 = 6.7; O = 53.3/16 = 3.33.\nStep 2: Divide by the smallest (3.33): C 1, H 2, O 1.\nStep 3: The empirical formula is CH2O.', T.emp);
add('The empirical formula of a compound is CH2O and its relative molecular mass is 180. What is its molecular formula? (C = 12, H = 1, O = 16)', 'C6H12O6', ['C3H6O3', 'C5H10O5', 'C12H24O12'],
  'Step 1: Mass of CH2O = 12 + 2 + 16 = 30.\nStep 2: n = 180 / 30 = 6.\nStep 3: Molecular formula = (CH2O)6 = C6H12O6.', T.emp);
add('An iron oxide contains 69.9% iron and 30.1% oxygen by mass. What is its empirical formula? (Fe = 55.85, O = 16)', 'Fe2O3', ['FeO', 'Fe3O4', 'FeO2'],
  'Step 1: Moles: Fe = 69.9/55.85 = 1.25; O = 30.1/16 = 1.88.\nStep 2: Divide by 1.25: Fe 1, O 1.5.\nStep 3: Multiply by 2 to clear the fraction: Fe2O3.', T.emp);
add('An oxide of nitrogen contains 30.4% nitrogen by mass. What is its empirical formula? (N = 14, O = 16)', 'NO2', ['NO', 'N2O', 'N2O3'],
  'Step 1: Oxygen = 69.6%. Moles: N = 30.4/14 = 2.17; O = 69.6/16 = 4.35.\nStep 2: Divide by 2.17: N 1, O 2.\nStep 3: Empirical formula NO2.', T.emp);
add('Why can the molecular formula not be found from percentage composition alone?', 'Because the relative molecular mass is also needed', ['Because percentages do not add up to 100', 'Because empirical formulae are always wrong', 'Because only metals have empirical formulae'],
  'Percentage composition gives only the simplest ratio of atoms, which is the empirical formula. The molecular formula is a whole-number multiple of it, and that multiple is found from the relative molecular mass.', T.emp);

// ---------------- gas stoichiometry
{ const n = 15.0 / 27 * 1.5, V = n * 62.36 * 298.15 / 735; chk(V, 21.08, 0.05);
  add('Calculate the volume of hydrogen liberated at 25 degrees Celsius and 735 mmHg when 15.0 g of aluminium reacts with excess dilute sulphuric acid. (Al = 27; R = 62.36 L mmHg K^-1 mol^-1)', '21.1 L', ['14.1 L', '28.1 L', '31.6 L'],
    'Step 1: 2Al + 3H2SO4 -> Al2(SO4)3 + 3H2.\nStep 2: Moles of Al = 15.0 / 27 = 0.556 mol.\nStep 3: Moles of H2 = 0.556 x 3/2 = 0.833 mol.\nStep 4: V = nRT/P = 0.833 x 62.36 x 298 / 735 = 21.1 L.', T.gas); }
{ chk(6.5 / 65 * 22.4, 2.24);
  add('What volume of hydrogen at STP is liberated when 6.5 g of zinc reacts with excess dilute hydrochloric acid? (Zn = 65; molar volume = 22.4 L at STP)', '2.24 L', ['1.12 L', '4.48 L', '22.4 L'],
    'Step 1: Zn + 2HCl -> ZnCl2 + H2.\nStep 2: Moles of Zn = 6.5 / 65 = 0.10 mol, which gives 0.10 mol of H2.\nStep 3: Volume = 0.10 x 22.4 = 2.24 L.', T.gas); }
{ chk(2.4 / 24 * 22.4, 2.24);
  add('Magnesium (2.4 g) reacts with excess dilute sulphuric acid. What volume of hydrogen is produced at STP? (Mg = 24)', '2.24 L', ['4.48 L', '1.12 L', '0.224 L'],
    'Step 1: Mg + H2SO4 -> MgSO4 + H2.\nStep 2: Moles of Mg = 2.4 / 24 = 0.10 mol, giving 0.10 mol of H2.\nStep 3: 0.10 x 22.4 = 2.24 L.', T.gas); }
{ chk(10 / 100 * 22.4, 2.24);
  add('Heating 10.0 g of calcium carbonate gives calcium oxide and carbon dioxide. What volume of CO2 is liberated at STP? (Ca = 40, C = 12, O = 16)', '2.24 L', ['4.48 L', '1.12 L', '22.4 L'],
    'Step 1: CaCO3 -> CaO + CO2. Molar mass of CaCO3 = 100 g/mol.\nStep 2: Moles = 10 / 100 = 0.10 mol, so 0.10 mol of CO2.\nStep 3: 0.10 x 22.4 = 2.24 L.', T.gas); }
add('In the reaction 2Al + 3H2SO4 -> Al2(SO4)3 + 3H2, how many moles of hydrogen are produced from 0.40 mol of aluminium?', '0.60 mol', ['0.27 mol', '0.40 mol', '1.20 mol'],
  'The mole ratio Al : H2 is 2 : 3. Moles of H2 = 0.40 x 3/2 = 0.60 mol.', T.gas);

// ---------------- concentration of stock solutions, dilution
{ const M = 98.7 / 100 * 1.84 * 1000 / 98; chk(M, 18.53);
  add('Concentrated sulphuric acid has a specific gravity of 1.84 and a purity of 98.7%. What is its molarity? (H2SO4 = 98)', '18.53 M', ['9.27 M', '1.85 M', '36.6 M'],
    'Step 1: Molarity = (% purity / 100 x density x 1000) / molar mass.\nStep 2: = (0.987 x 1.84 x 1000) / 98 = 18.53 M.', T.mol); }
{ const V = 0.01 * 1000 / 18.53; chk(V, 0.54);
  add('Using the stock sulphuric acid of molarity 18.53 M, what volume is needed to prepare 1.00 dm3 of 0.01 M acid?', '0.54 cm3', ['5.4 cm3', '1.85 cm3', '54 cm3'],
    'Step 1: C1V1 = C2V2.\nStep 2: V1 = (0.01 x 1000 cm3) / 18.53 = 0.54 cm3.', T.mol); }
{ const M = 36 / 100 * 1.18 * 1000 / 36.5; chk(M, 11.64);
  add('Concentrated hydrochloric acid is 36% HCl by mass with a density of 1.18 g/cm3. What is its molarity? (HCl = 36.5)', '11.64 M', ['10.00 M', '12.00 M', '5.82 M'],
    'Step 1: Molarity = (0.36 x 1.18 x 1000) / 36.5.\nStep 2: = 424.8 / 36.5 = 11.64 M.', T.mol); }
{ const V = 0.1 * 500 / 11.64; chk(V, 4.30);
  add('How much of the 11.64 M stock hydrochloric acid is needed to prepare 500 cm3 of 0.10 M HCl?', '4.30 cm3', ['43.0 cm3', '0.43 cm3', '5.82 cm3'],
    'Step 1: C1V1 = C2V2.\nStep 2: V1 = (0.10 x 500) / 11.64 = 4.30 cm3.', T.mol); }
{ const M = 70 / 100 * 1.42 * 1000 / 63; chk(M, 15.78);
  add('Concentrated nitric acid is 70% HNO3 by mass with a density of 1.42 g/cm3. Calculate its molarity. (HNO3 = 63)', '15.78 M', ['9.94 M', '22.5 M', '7.89 M'],
    'Step 1: (0.70 x 1.42 x 1000) / 63.\nStep 2: = 994 / 63 = 15.78 M.', T.mol); }
add('What is the relationship used to prepare a dilute solution from a stock solution?', 'C1V1 = C2V2', ['C1 + V1 = C2 + V2', 'C1/V1 = C2/V2', 'C1C2 = V1V2'],
  'The number of moles of solute stays the same on dilution, so concentration x volume is the same before and after: C1V1 = C2V2.', T.mol);

// ---------------- solution stoichiometry (ammonia)
{ const M = 18 / 100 * 0.93 * 1000 / 17; chk(M, 9.85);
  add('A solution of ammonia in water is 18% NH3 by mass and has a density of 0.93 g/cm3. What is its molarity? (NH3 = 17)', '9.85 M', ['18.0 M', '5.29 M', '16.7 M'],
    'Step 1: Molarity = (0.18 x 0.93 x 1000) / 17.\nStep 2: = 167.4 / 17 = 9.85 M.', T.sol); }
{ const nS = 30 / 132, nNH3 = 2 * nS, V = nNH3 / 9.847 * 1000; chk(V, 46.2, 0.3);
  add('What volume of the ammonia solution (9.85 M) is needed to form 30 g of ammonium sulphate by 2NH3 + H2SO4 -> (NH4)2SO4? ((NH4)2SO4 = 132)', '46.2 cm3', ['23.1 cm3', '92.4 cm3', '4.62 cm3'],
    'Step 1: Moles of (NH4)2SO4 = 30 / 132 = 0.227 mol.\nStep 2: The ratio NH3 : (NH4)2SO4 is 2 : 1, so NH3 needed = 0.454 mol.\nStep 3: Volume = 0.454 / 9.85 = 0.0462 dm3 = 46.2 cm3.', T.sol); }
{ chk(25 * 0.2 / 1000 * 2 / 0.1 * 1000 / 2 , 50);
  add('What volume of 0.20 M NaOH neutralises 25.0 cm3 of 0.20 M H2SO4? (H2SO4 + 2NaOH -> Na2SO4 + 2H2O)', '50.0 cm3', ['25.0 cm3', '12.5 cm3', '100 cm3'],
    'Step 1: Moles of H2SO4 = 0.20 x 0.0250 = 0.0050 mol.\nStep 2: NaOH needed = 2 x 0.0050 = 0.010 mol.\nStep 3: Volume = 0.010 / 0.20 = 0.050 dm3 = 50.0 cm3.', T.sol); }
add('What is the percentage yield if 8.0 g of product is obtained when the theoretical yield is 10.0 g?', '80%', ['8%', '125%', '20%'],
  'Percentage yield = (actual yield / theoretical yield) x 100 = (8.0 / 10.0) x 100 = 80%.', T.sol);

// ---------------- Millikan, Rutherford
add("In Millikan's oil drop experiment, the charges on the drops were always:", 'Whole-number multiples of a smallest charge, 1.602 x 10^-19 C', ['Any value between 0 and 1.602 x 10^-19 C', 'Equal to the charge of the proton divided by 2', 'Zero'],
  'Millikan found that every drop carried a charge that was a whole-number multiple of one basic unit, the charge on the electron, 1.602 x 10^-19 C.', T.mil);
{ chk(3.204e-19 / 1.602e-19, 2);
  add("A Millikan oil drop carries a charge of 3.204 x 10^-19 C. How many excess electrons does it carry?", '2', ['1', '3', '4'],
    'Step 1: Number of electrons = total charge / charge of one electron.\nStep 2: = 3.204 x 10^-19 / 1.602 x 10^-19 = 2.', T.mil); }
add("In the Millikan experiment, the retarding force on a falling drop of radius r and velocity v in a fluid of viscosity eta is given by:", "Stokes' law, 6 x pi x eta x r x v", ['Hooke\'s law, kx', "Newton's law of cooling", "Boyle's law, PV"],
  "The viscous drag on a small sphere moving through a fluid is given by Stokes' law: F = 6 pi eta r v. At constant velocity the forces on the drop balance.", T.mil);
add("In Rutherford's alpha-particle scattering experiment, most alpha particles passed straight through the gold foil. This showed that:", 'The atom is mostly empty space', ['The atom is a solid sphere of positive charge', 'Electrons are heavier than alpha particles', 'The nucleus is negatively charged'],
  'Over 99% of the particles went undeflected, so most of the atom is empty space. A few were deflected, which showed a small, dense, positively charged nucleus.', T.ruth);

// ---------------- Bohr model calculations
{ const dE = 13.6 * (1 - 1 / 4); chk(dE, 10.2); chk(dE * 1.6e-19, 1.632e-18, 1e-20);
  add('Calculate the energy difference between the n = 1 and n = 2 levels of the hydrogen atom. (Use 13.6 eV; 1 eV = 1.6 x 10^-19 J)', '10.2 eV (1.63 x 10^-18 J)', ['3.4 eV (5.4 x 10^-19 J)', '13.6 eV (2.18 x 10^-18 J)', '1.9 eV (3.0 x 10^-19 J)'],
    'Step 1: delta E = 13.6 (1/1^2 - 1/2^2) eV.\nStep 2: = 13.6 x 3/4 = 10.2 eV.\nStep 3: In joules: 10.2 x 1.6 x 10^-19 = 1.63 x 10^-18 J.', T.bohr); }
{ const dE = 13.6 * (1 / 4 - 1 / 9); chk(dE, 1.889); chk(dE * 1.6e-19, 3.022e-19, 1e-21);
  add('Calculate the energy of the first line of the Balmer series of hydrogen (n = 3 to n = 2). (Use 13.6 eV; 1 eV = 1.6 x 10^-19 J)', '1.889 eV (3.02 x 10^-19 J)', ['10.2 eV (1.63 x 10^-18 J)', '0.66 eV (1.0 x 10^-19 J)', '3.4 eV (5.4 x 10^-19 J)'],
    'Step 1: The Balmer series ends on n = 2, and the first line starts from n = 3.\nStep 2: delta E = 13.6 (1/4 - 1/9) = 13.6 x 5/36 = 1.889 eV.\nStep 3: In joules: 1.889 x 1.6 x 10^-19 = 3.02 x 10^-19 J.', T.bohr); }
{ const lam = 6.626e-34 * 3.0e8 / 3.022e-19; chk(lam * 1e9, 657.8, 1);
  add('What is the wavelength of the first Balmer line of hydrogen, if its energy is 3.022 x 10^-19 J? (h = 6.626 x 10^-34 J s; c = 3.0 x 10^8 m/s)', '658 nm', ['486 nm', '121 nm', '434 nm'],
    'Step 1: lambda = hc / E.\nStep 2: = (6.626 x 10^-34 x 3.0 x 10^8) / 3.022 x 10^-19.\nStep 3: = 6.58 x 10^-7 m = 658 nm, which is red light.', T.bohr); }
{ const lam = 1240 / 10.2; chk(lam, 121.6, 0.2);
  add('The first line of the Lyman series of hydrogen (n = 2 to n = 1) corresponds to an energy of 10.2 eV. What is its wavelength? (hc = 1240 eV nm)', '121.6 nm', ['656 nm', '486 nm', '12.2 nm'],
    'Step 1: lambda = hc / E = 1240 eV nm / 10.2 eV.\nStep 2: = 121.6 nm, in the ultraviolet region.', T.bohr); }
{ chk(-13.6 / 9, -1.511, 0.01);
  add('What is the energy of the electron in the n = 3 level of hydrogen? (E_n = -13.6 / n^2 eV)', '-1.51 eV', ['-4.53 eV', '-3.40 eV', '+1.51 eV'],
    'Step 1: E3 = -13.6 / 3^2 = -13.6 / 9.\nStep 2: = -1.51 eV. The energy is negative because the electron is bound.', T.bohr); }
{ const R = 9.109e-31 * (1.602e-19) ** 4 / (8 * (8.854e-12) ** 2 * (6.626e-34) ** 3 * 2.998e8); chk(R / 1e7, 1.0973, 0.003);
  add('The Rydberg constant for hydrogen, obtained from Bohr theory using the electron mass, the electron charge, the Planck constant and the speed of light, has a value of about:', '1.097 x 10^7 per metre', ['1.097 x 10^-7 per metre', '6.626 x 10^-34 per metre', '3.0 x 10^8 per metre'],
    'In SI units R = m e^4 / (8 eps0^2 h^3 c). Substituting m = 9.109 x 10^-31 kg, e = 1.602 x 10^-19 C, h = 6.626 x 10^-34 J s and c = 3.0 x 10^8 m/s gives R = 1.097 x 10^7 m^-1.', T.bohr); }
add('In Bohr theory the total energy of an electron in an orbit is E = -2 pi^2 m Z^2 e^4 / (n^2 h^2). It is the sum of:', 'Kinetic energy (+Ze^2/2r) and potential energy (-Ze^2/r)', ['Kinetic energy only', 'Potential energy only', 'Nuclear energy and kinetic energy'],
  'Kinetic energy = Ze^2/2r and potential energy = -Ze^2/r. Their sum is -Ze^2/2r, and substituting the Bohr radius gives the energy formula.', T.bohr);

// ---------------- photoelectric effect
{ const E = 6.626e-34 * 3.0e8 / 500e-9; chk(E / 1.6e-19, 2.49, 0.02);
  add('What is the energy of a photon of light of wavelength 500 nm in electron volts? (h = 6.626 x 10^-34 J s; c = 3.0 x 10^8 m/s; 1 eV = 1.6 x 10^-19 J)', '2.49 eV', ['4.97 eV', '1.24 eV', '0.25 eV'],
    'Step 1: E = hc / lambda = (6.626 x 10^-34 x 3.0 x 10^8) / (500 x 10^-9) = 3.98 x 10^-19 J.\nStep 2: In eV: 3.98 x 10^-19 / 1.6 x 10^-19 = 2.49 eV.\nShortcut: E (eV) = 1240 / lambda (nm) = 1240 / 500 = 2.48 eV.', T.pe); }
add('A metal has a work function of 2.0 eV. If a photon of energy 3.5 eV falls on it, what is the maximum kinetic energy of the ejected electron?', '1.5 eV', ['5.5 eV', '2.0 eV', '3.5 eV'],
  'Step 1: Photon energy = work function + kinetic energy, so hf = W0 + KE.\nStep 2: KE = 3.5 - 2.0 = 1.5 eV.', T.pe);
add('In the equation hf = W0 + KE, the term W0 represents:', 'The work function, the minimum energy needed to eject an electron', ['The kinetic energy of the photon', 'The frequency of the light', 'The total energy of the electron in the atom'],
  'W0 is the work function of the metal. A photon must supply at least this energy before an electron can leave the surface.', T.pe);

// ---------------- electronic configuration
add('Which of the following is the electronic configuration of a chromium atom (Z = 24)?', '1s2 2s2 2p6 3s2 3p6 4s1 3d5', ['1s2 2s2 2p6 3s2 3p6 4s2 3d4', '1s2 2s2 2p6 3s2 3p6 3d6', '1s2 2s2 2p6 3s2 3p6 4s1 3d4'],
  'Chromium takes one electron from 4s so that the 3d subshell is half-filled (3d5). A half-filled d subshell is more stable than 4s2 3d4.', T.conf);
add('Vanadium (Z = 23) has two electrons in its 4s orbital, but chromium (Z = 24) has one. The reason is that:', 'Chromium gains extra stability from a half-filled 3d subshell (3d5)', ['Chromium has fewer electrons than vanadium', 'Vanadium has a half-filled 3d subshell', 'The 4s orbital cannot hold two electrons in chromium'],
  'Vanadium is 4s2 3d3, which follows the normal filling order. Chromium moves one 4s electron into 3d to reach the more stable half-filled 3d5.', T.conf);
add('Write the electronic configuration of copper (Z = 29).', '1s2 2s2 2p6 3s2 3p6 4s1 3d10', ['1s2 2s2 2p6 3s2 3p6 4s2 3d9', '1s2 2s2 2p6 3s2 3p6 3d11', '1s2 2s2 2p6 3s2 3p6 4s2 3d10'],
  'Copper has a completely filled 3d subshell (3d10) and one 4s electron. A full d subshell is extra stable.', T.conf);
add('The electronic configuration of zinc (Z = 30) is:', '1s2 2s2 2p6 3s2 3p6 4s2 3d10', ['1s2 2s2 2p6 3s2 3p6 4s1 3d10', '1s2 2s2 2p6 3s2 3p6 4s2 3d8', '1s2 2s2 2p6 3s2 3p6 3d12'],
  'Zinc has 30 electrons: [Ar] 4s2 3d10. Its d subshell is full, so it shows only the +2 oxidation state.', T.conf);
add('Which element has a single electron in its 3d sublevel?', 'Scandium', ['Yttrium', 'Lanthanum', 'Titanium'],
  'Scandium (Z = 21) is [Ar] 4s2 3d1. Yttrium has its single electron in 4d and lanthanum in 5d.', T.conf);
add('Arrange the orbitals 3p, 3d, 5p, 6s and 7s in order of increasing energy using the (n + l) rule.', '3p < 3d < 5p < 6s < 7s', ['7s < 6s < 5p < 3d < 3p', '3d < 3p < 5p < 6s < 7s', '3p < 3d < 6s < 5p < 7s'],
  'Step 1: (n + l): 3p = 4, 3d = 5, 5p = 6, 6s = 6, 7s = 7.\nStep 2: A lower (n + l) means lower energy. For equal (n + l), the lower n is filled first, so 5p comes before 6s.\nStep 3: The order is 3p < 3d < 5p < 6s < 7s.', T.conf);
add('The Pauli exclusion principle states that:', 'No two electrons in an atom can have the same four quantum numbers', ['Orbitals of equal energy are filled singly before pairing', 'Electrons fill the lowest energy orbitals first', 'The position and momentum of an electron cannot both be known exactly'],
  'Pauli exclusion principle: no two electrons in the same atom can have the same values of n, l, ml and ms. An orbital therefore holds at most two electrons, with opposite spins.', T.conf);
add("Hund's rule of maximum multiplicity states that:", 'Electrons occupy degenerate orbitals singly, with parallel spins, before pairing', ['No two electrons have the same four quantum numbers', 'Orbitals are filled in order of increasing (n + l)', 'An orbital can hold at most two electrons'],
  'In degenerate orbitals such as the three 2p orbitals, electrons fill each orbital singly with parallel spins before any pairing begins.', T.conf);
add('Which of the following species are isoelectronic with neon (10 electrons)?', 'O2-, F- and Na+', ['Cl-, K+ and Ca2+', 'O2-, Cl- and K+', 'Li+, Na+ and K+'],
  'Neon has 10 electrons. O2- (8 + 2), F- (9 + 1) and Na+ (11 - 1) all have 10. Cl-, K+ and Ca2+ have 18 electrons like argon.', T.iso);
add('Cl- and K+ are isoelectronic. How many electrons does each have?', '18', ['17', '19', '10'],
  'Cl- has 17 + 1 = 18 electrons and K+ has 19 - 1 = 18 electrons, the same as argon.', T.iso);
add('Why are NH4+ and CH4 isoelectronic?', 'Each has 10 electrons', ['Each has 4 hydrogen atoms and so the same charge', 'Each has 5 atoms with the same mass', 'Each has a lone pair on the central atom'],
  'NH4+ has 7 + 4 - 1 = 10 electrons and CH4 has 6 + 4 = 10 electrons, the same as neon.', T.iso);
add('Arrange the species O2-, F-, Na+, Mg2+ in order of decreasing ionic radius.', 'O2- > F- > Na+ > Mg2+', ['Mg2+ > Na+ > F- > O2-', 'F- > O2- > Na+ > Mg2+', 'Na+ > Mg2+ > O2- > F-'],
  'All four have 10 electrons. A higher nuclear charge pulls the electron cloud in more strongly, so the radius falls as the atomic number rises: O (8) < F (9) < Na (11) < Mg (12).', T.iso);

// ---------------- molecular orbital theory
add('Using molecular orbital theory, which of the following oxygen species is diamagnetic?', 'O2 2- (peroxide ion)', ['O2', 'O2-', 'O2+'],
  'O2 2- has all its electrons paired in the molecular orbitals, so it is diamagnetic. O2, O2- and O2+ each have unpaired electrons in the pi* orbitals.', T.mo);
add('How many unpaired electrons does the O2 molecule have according to molecular orbital theory?', '2', ['0', '1', '4'],
  'The last two electrons occupy the two degenerate pi* 2p orbitals singly, with parallel spins (Hund\'s rule). The molecule is paramagnetic.', T.mo);
add('What is the bond order of O2+ according to molecular orbital theory?', '2.5', ['2', '1.5', '3'],
  'O2+ has 15 valence electrons: 10 bonding and 5 antibonding. Bond order = (10 - 5)/2 = 2.5.', T.mo);
add('Arrange O2+, O2, O2- and O2 2- in order of decreasing bond order.', 'O2+ > O2 > O2- > O2 2-', ['O2 2- > O2- > O2 > O2+', 'O2 > O2+ > O2- > O2 2-', 'O2+ > O2- > O2 > O2 2-'],
  'Bond orders: O2+ = 2.5, O2 = 2, O2- = 1.5 and O2 2- = 1. Adding electrons to the antibonding pi* orbitals lowers the bond order.', T.mo);
add('The consequence of unpaired electrons in an atom or molecule is that it is:', 'Paramagnetic, attracted by a magnetic field', ['Diamagnetic, repelled by a magnetic field', 'Always ionic', 'Always a gas'],
  'Substances with unpaired electrons are paramagnetic and are drawn into a magnetic field. Substances with all electrons paired are diamagnetic and are weakly repelled.', T.mo);

// ---------------- periodic trends, ionization energy anomalies
add('Why is the first ionization energy of boron (8.30 eV) lower than that of beryllium (9.33 eV)?', 'Beryllium has a stable, filled 2s subshell, so its electron is harder to remove', ['Boron has a smaller nuclear charge', 'Beryllium has more electron shells', 'Boron has a half-filled 2p subshell'],
  'Be is 1s2 2s2 with a filled 2s subshell. B is 1s2 2s2 2p1, and its outer electron is in the higher-energy 2p orbital, which is easier to remove.', T.ion);
add('The first ionization energy of nitrogen is slightly higher than that of oxygen because:', 'Nitrogen has a half-filled, stable 2p subshell', ['Nitrogen has a larger atomic radius', 'Oxygen has a half-filled 2p subshell', 'Nitrogen has a larger nuclear charge'],
  'Nitrogen is 2p3 with one electron in each 2p orbital (half-filled), which is stable. Oxygen is 2p4, and the paired electron is repelled by its partner, so it is easier to remove.', T.ion);
add('Across a period of the periodic table, from left to right, atomic radius ____ and first ionization energy generally ____.', 'decreases; increases', ['increases; increases', 'decreases; decreases', 'increases; decreases'],
  'Across a period the nuclear charge rises while the shielding stays about the same, so the electrons are pulled in closer. The radius falls and more energy is needed to remove an electron.', T.per);
add('Going down a group of the periodic table, electronegativity generally:', 'decreases', ['increases', 'stays the same', 'first increases then decreases'],
  'Atoms get bigger and the outer electrons are further from the nucleus and more shielded, so the atom attracts bonding electrons less strongly.', T.per);
add('Why is the O2- ion larger than the oxygen atom?', 'It gains two electrons, so electron repulsion increases while the nuclear charge stays the same', ['It loses two electrons', 'Its nuclear charge increases', 'It has fewer electron shells'],
  'Adding electrons increases repulsion between them while the nucleus still has 8 protons, so the electron cloud expands.', T.per);
add('Why is the N3+ ion smaller than the nitrogen atom?', 'Fewer electrons are held by the same nuclear charge, so the cloud contracts', ['It has more electrons than the atom', 'Its nuclear charge falls', 'It gains an extra shell'],
  'A cation has fewer electrons than protons, so the nucleus pulls the remaining electrons in more strongly, and the outer shell may be lost.', T.per);

// ---------------- bonding
add('Water boils at a much higher temperature than H2S, H2Se and H2Te because:', 'Water molecules form hydrogen bonds with each other', ['Water has a larger molar mass', 'Water is an ionic compound', 'Water has a smaller bond angle'],
  'Oxygen is very electronegative and small, so O-H bonds are strongly polar and water molecules hydrogen-bond. The other group 16 hydrides cannot do this.', T.bond);
add('The bonding in the ammonium chloride (NH4Cl) crystal includes:', 'Ionic bonds between NH4+ and Cl-, covalent N-H bonds and one dative bond', ['Metallic bonds only', 'Ionic bonds only', 'Hydrogen bonds only'],
  'NH4+ and Cl- are held by ionic bonding. Within NH4+ the N-H bonds are covalent, and one of them is a coordinate (dative) bond because both electrons came from nitrogen\'s lone pair.', T.bond);
add('In a Lewis structure, the nitrogen molecule N2 has:', 'A triple bond and one lone pair on each atom', ['A double bond and two lone pairs on each atom', 'A single bond and three lone pairs on each atom', 'No bond between the atoms'],
  'Each nitrogen has five valence electrons. Sharing three pairs gives each atom an octet: N triple-bond N, with one lone pair on each atom.', T.bond);
add('Which of the following correctly shows the type of bond in each substance?', 'H2S - covalent; Cu - metallic; NaCl - ionic', ['H2S - ionic; Cu - covalent; NaCl - metallic', 'H2S - metallic; Cu - ionic; NaCl - covalent', 'H2S - covalent; Cu - ionic; NaCl - metallic'],
  'H2S forms by sharing electrons (covalent). Copper is a metal with delocalised outer electrons (metallic). Sodium chloride forms by transfer of an electron from Na to Cl (ionic).', T.bond);
add('Which property is typical of ionic compounds but not of simple covalent compounds?', 'High melting and boiling points, and conduction when molten or dissolved', ['Low melting points and no conduction in water', 'Soluble in organic solvents but not in water', 'Exist only as gases at room temperature'],
  'Ionic compounds are held in a lattice by strong electrostatic forces, so they melt at high temperatures and conduct when their ions are free to move.', T.bond);

// ---------------- hydrogen
add('Hydrogen can be prepared in the laboratory by the action of dilute acid on a metal. Which equation shows this?', 'Zn + H2SO4 -> ZnSO4 + H2', ['Zn + H2O -> ZnO + H2O', 'Cu + H2SO4 -> CuSO4 + H2', 'Zn + 2NaOH -> Na2ZnO2 + O2'],
  'A metal above hydrogen in the reactivity series, such as zinc, displaces hydrogen from dilute acid. Copper is below hydrogen and does not react.', T.hyd);
add('Which of the following also liberates hydrogen gas?', 'Aluminium with sodium hydroxide solution', ['Copper with dilute sulphuric acid', 'Silver with dilute hydrochloric acid', 'Gold with water'],
  '2Al + 2NaOH + 6H2O -> 2Na[Al(OH)4] + 3H2. Aluminium is amphoteric and reacts with a strong alkali.', T.hyd);
add('Water gas is prepared by passing steam over red-hot coke. The equation is:', 'C + H2O -> CO + H2', ['C + 2H2 -> CH4', 'CO + H2O -> CO2 + H2', '2C + O2 -> 2CO'],
  'At about 1000 degrees Celsius carbon reduces steam to give carbon monoxide and hydrogen, a mixture called water gas. Passing it with more steam over iron(III) oxide at about 450 degrees Celsius converts CO to CO2 and gives more hydrogen.', T.hyd);
add('Salt-like hydrides such as lithium hydride react with water to give:', 'Hydrogen gas and a metal hydroxide', ['Oxygen and a metal oxide', 'Hydrogen peroxide', 'Hydrochloric acid'],
  'LiH + H2O -> LiOH + H2. The hydride ion H- is a strong base and a reducing agent.', T.hyd);
add('Deuterium is an isotope of hydrogen with:', 'One proton and one neutron (mass number 2)', ['One proton and two neutrons', 'Two protons and no neutrons', 'One proton and no neutrons'],
  'Deuterium is 2H: atomic number 1 and mass number 2, so it has one proton and one neutron. Tritium (3H) has two neutrons.', T.hyd);
add('In ortho-hydrogen and para-hydrogen, the two nuclei have:', 'Parallel spins in ortho-hydrogen and opposite spins in para-hydrogen', ['Opposite spins in ortho-hydrogen and parallel spins in para-hydrogen', 'Different numbers of neutrons', 'Different numbers of electrons'],
  'These are two nuclear-spin isomers of H2. Ortho-hydrogen has parallel nuclear spins; para-hydrogen has antiparallel spins and is the lower-energy form.', T.hyd);
add('Balance the equation NH3 + Cl2 -> NH4Cl + N2. The balanced equation is:', '8NH3 + 3Cl2 -> 6NH4Cl + N2', ['2NH3 + Cl2 -> 2NH4Cl + N2', '4NH3 + 3Cl2 -> 6NH4Cl + N2', 'NH3 + Cl2 -> NH4Cl + N2'],
  'Step 1: Put 6NH4Cl so that 6 Cl atoms balance 3Cl2.\nStep 2: Nitrogen needed: 6 (in NH4Cl) + 2 (in N2) = 8, so 8NH3.\nStep 3: Hydrogen check: 24 on the left, 24 on the right (6 x 4).', T.hyd);

// ---------------- transition elements and alloys
add('Which of the following transition elements shows the widest range of oxidation states?', 'Manganese (+2 to +7)', ['Zinc (+2 only)', 'Scandium (+3 only)', 'Copper (+1 and +2 only)'],
  'Manganese uses its 4s and 3d electrons and shows +2, +3, +4, +5, +6 and +7. Zinc and scandium show only one common oxidation state.', T.tm);
add('Which of the following is a characteristic property of transition elements?', 'They form coloured compounds and complexes', ['They form only colourless ions', 'They never form complexes', 'They have only one oxidation state'],
  'Partly filled d orbitals give transition elements variable oxidation states, coloured compounds, complex formation, catalytic activity and often paramagnetism.', T.tm);
add('Transition metal compounds are often paramagnetic because:', 'They have unpaired d electrons', ['They have no d electrons', 'They contain only paired electrons', 'They are all ionic'],
  'Partly filled d subshells contain unpaired electrons, which are attracted by a magnetic field.', T.tm);
add('Which of the following does zinc show as a common oxidation state?', '+2 only', ['+1 and +2', '+2 to +7', '+3 and +4'],
  'Zinc is [Ar] 4s2 3d10. It loses its two 4s electrons to give Zn2+ with a full d subshell, and does not go beyond that.', T.tm);
add('Stainless steel is an alloy of iron with:', 'Chromium and nickel', ['Tungsten and carbon', 'Nickel and molybdenum', 'Manganese and silicon'],
  'Stainless steel contains iron, chromium and nickel. The chromium forms a protective oxide layer, so it resists corrosion and is used for cutlery and kitchenware.', T.alloy);
add('Invar, an alloy of iron and nickel, is used for surveying tapes and watch parts because:', 'It expands very little when the temperature changes', ['It is magnetic', 'It conducts electricity very well', 'It is very hard'],
  'Invar has an extremely small coefficient of thermal expansion, so measurements made with it stay accurate over a range of temperatures.', T.alloy);
add('Permalloy, an alloy of nickel, iron and molybdenum, is used for:', 'Transformer cores and magnetic recording heads', ['Cutlery and kitchenware', 'Surveying tapes', 'Light bulb filaments'],
  'Permalloy magnetises and demagnetises very easily (high magnetic permeability), which suits transformer laminations and recording heads.', T.alloy);

module.exports = out;
