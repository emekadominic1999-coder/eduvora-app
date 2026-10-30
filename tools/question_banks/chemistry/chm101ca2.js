// CHM 101 (General Chemistry I) - original questions on Unit 7 of the continuous assessment: radioactivity and its applications.
const L = require('../sta/lib');
const { add, out } = L;
const chk = (a, b, tol = 0.01) => { if (Math.abs(a - b) > tol) throw new Error('check failed ' + a + ' vs ' + b); };
const T = {
  hl: 'Half-Life Calculations', dec: 'Radioactive Decay Law', nuc: 'Nuclear Equations', bind: 'Mass Defect and Binding Energy', app: 'Applications of Radioisotopes', dat: 'Radioactive Dating', ser: 'Radioactive Decay Series',
};

// ---------------- decay law and half-life
add('Starting from the rate law dN/dt = -lambda N, the half-life of a radioactive nuclide is related to the decay constant by:', 't1/2 = 0.693 / lambda', ['t1/2 = lambda / 0.693', 't1/2 = 0.693 x lambda', 't1/2 = 1 / (0.693 lambda)'],
  'Step 1: Integrating gives ln(N/N0) = -lambda t.\nStep 2: At the half-life N = N0/2, so ln(1/2) = -lambda t1/2.\nStep 3: ln 2 = 0.693, so t1/2 = 0.693 / lambda.', T.dec);
add('The fraction of a radioactive sample that remains after a time t is given by:', 'N/N0 = e^(-lambda t)', ['N/N0 = e^(lambda t)', 'N/N0 = 1 - lambda t', 'N/N0 = lambda / t'],
  'Integrating dN/dt = -lambda N gives N = N0 e^(-lambda t), so the fraction left is e^(-lambda t).', T.dec);
{ const lam = Math.log(2) / (30 * 24 * 3600), rate = lam * 1e15; chk(rate / 1e8, 2.674, 0.01);
  add('A radioactive substance contains 10^15 atoms and has a half-life of 30 days. How many disintegrations occur per second at the start?', '2.67 x 10^8 per second', ['2.67 x 10^6 per second', '3.85 x 10^9 per second', '1.15 x 10^7 per second'],
    'Step 1: 30 days = 30 x 24 x 3600 = 2.592 x 10^6 s.\nStep 2: lambda = 0.693 / 2.592 x 10^6 = 2.67 x 10^-7 per second.\nStep 3: dN/dt = lambda N = 2.67 x 10^-7 x 10^15 = 2.67 x 10^8 disintegrations per second.', T.hl); }
{ const lam = Math.log(2) / (30 * 24 * 3600), t = Math.log(1e15 / 1e7) / lam / 86400; chk(t, 797.4, 0.5);
  add('For the same substance (10^15 atoms, half-life 30 days), how long will it take for the number of atoms to fall to 10^7?', 'About 797 days', ['About 30 days', 'About 240 days', 'About 1 500 days'],
    'Step 1: t = (1/lambda) ln(N0/N) = (1/2.67 x 10^-7) x ln(10^8).\nStep 2: ln(10^8) = 18.42, so t = 18.42 / 2.67 x 10^-7 = 6.9 x 10^7 s.\nStep 3: In days: 6.9 x 10^7 / 86 400 = about 797 days.\nShortcut: 10^8 is about 2^26.6, so about 26.6 half-lives x 30 days = 797 days.', T.hl); }
{ const f = Math.exp(-Math.log(2) * 10000 / 1620); chk(f, 0.01388, 0.0005);
  add('The half-life of radium is 1620 years. What mass of a 1.00 g sample remains after 10 000 years?', '0.0139 g', ['0.139 g', '0.50 g', '0.0062 g'],
    'Step 1: N = N0 e^(-0.693 t / t1/2).\nStep 2: Exponent = 0.693 x 10 000 / 1620 = 4.278.\nStep 3: N = 1.00 x e^(-4.278) = 0.0139 g.', T.hl); }
{ chk(1 - Math.exp(-Math.log(2) * 10000 / 1620), 0.9861, 0.001);
  add('A 1.00 g sample of radium (half-life 1620 years) decays for 10 000 years. What mass has decayed?', '0.986 g', ['0.0139 g', '0.50 g', '0.693 g'],
    'Step 1: Mass remaining = 1.00 x e^(-4.278) = 0.0139 g.\nStep 2: Mass decayed = 1.00 - 0.0139 = 0.986 g.', T.hl); }
add('A radioactive isotope has a half-life of 8 days. What fraction of the original sample remains after 24 days?', '1/8', ['1/3', '1/4', '1/6'],
  'Step 1: Number of half-lives = 24 / 8 = 3.\nStep 2: Fraction left = (1/2)^3 = 1/8.\nShortcut: for a whole number of half-lives n, the fraction left is 1/2^n.', T.hl);
add('The half-life of carbon-14 is 5730 years. A wooden artefact has one quarter of the C-14 found in living wood. How old is it?', '11 460 years', ['5 730 years', '17 190 years', '22 920 years'],
  'Step 1: One quarter = (1/2)^2, so two half-lives have passed.\nStep 2: Age = 2 x 5730 = 11 460 years.', T.dat);
{ const lam = Math.log(2) / 5730, t = Math.log(1 / 0.125) / lam; chk(t, 17190, 5);
  add('A sample contains 12.5% of its original carbon-14 (half-life 5730 years). Estimate its age.', '17 190 years', ['11 460 years', '5 730 years', '22 920 years'],
    '12.5% = 1/8 = (1/2)^3, so three half-lives have passed: 3 x 5730 = 17 190 years.', T.dat); }
add('The decay constant of a nuclide is 0.0231 per day. What is its half-life?', '30 days', ['3 days', '0.016 days', '300 days'],
  'Step 1: t1/2 = 0.693 / lambda.\nStep 2: = 0.693 / 0.0231 = 30 days.', T.hl);
add('After how many half-lives does the activity of a sample fall below 1% of its starting value?', '7 half-lives', ['3 half-lives', '5 half-lives', '10 half-lives'],
  '(1/2)^6 = 1/64 = 1.56%, which is above 1%. (1/2)^7 = 1/128 = 0.78%, which is below 1%. So 7 half-lives are needed.', T.hl);

// ---------------- radiometric dating with uranium
{ const lam = Math.log(2) / 4.5e9, dU = 0.277 * 238 / 206, N0 = 1.67 + dU, t = Math.log(N0 / 1.67) / lam; chk(t / 1e9, 1.136, 0.01);
  add('A uranium ore contains 1.67 g of 238U for every 0.277 g of 206Pb. Taking all the lead as the product of decay of the uranium, and the half-life of 238U as 4.5 x 10^9 years, estimate the age of the ore. (Atomic masses: U = 238, Pb = 206)', 'About 1.1 x 10^9 years', ['About 4.0 x 10^8 years', 'About 4.5 x 10^9 years', 'About 2.3 x 10^9 years'],
    'Step 1: The 0.277 g of Pb came from 0.277 x 238/206 = 0.320 g of uranium.\nStep 2: Original uranium N0 = 1.67 + 0.320 = 1.99 g, and N = 1.67 g.\nStep 3: lambda = 0.693 / 4.5 x 10^9 = 1.54 x 10^-10 per year.\nStep 4: t = (1/lambda) ln(N0/N) = ln(1.19) / 1.54 x 10^-10 = 1.1 x 10^9 years.', T.dat); }

// ---------------- nuclear equations
add('Complete the nuclear equation: 14N + 4He -> 17O + M. Particle M is:', 'A proton (1H)', ['A neutron', 'An alpha particle', 'A beta particle'],
  'Mass numbers: 14 + 4 = 18, so M has mass number 18 - 17 = 1. Atomic numbers: 7 + 2 = 9, so M has Z = 9 - 8 = 1. A particle with A = 1 and Z = 1 is a proton.', T.nuc);
add('In the reaction 2H + 7Li -> 2M, particle M is:', 'Helium-4 (an alpha particle)', ['A proton', 'A deuteron', 'Beryllium-4'],
  'Total mass number = 2 + 7 = 9 and total atomic number = 1 + 3 = 4. Two helium nuclei (2 x 4He) account for 8 and 4, so the remaining mass number 1 with Z = 0 is a neutron released with them. So M = 4He.', T.nuc);
add('Complete the equation 9Be + 4He -> M + n. The product M is:', 'Carbon-12', ['Boron-12', 'Carbon-13', 'Beryllium-12'],
  'Mass number: 9 + 4 = 13, minus 1 for the neutron gives 12. Atomic number: 4 + 2 = 6, which is carbon. So M = 12C.', T.nuc);
add('Complete the equation 35Cl + n -> M + 1H. The product M is:', 'Sulphur-35', ['Phosphorus-35', 'Chlorine-36', 'Sulphur-36'],
  'Mass number: 35 + 1 = 36, minus 1 for the proton gives 35. Atomic number: 17 + 0 = 17, minus 1 gives 16, which is sulphur. So M = 35S.', T.nuc);
add('When a nucleus emits an alpha particle, its mass number and atomic number change by:', 'Mass number falls by 4 and atomic number by 2', ['Mass number falls by 2 and atomic number by 4', 'Mass number falls by 4 and atomic number rises by 2', 'Mass number is unchanged and atomic number falls by 2'],
  'An alpha particle is a helium nucleus, 4He, with 2 protons and 2 neutrons. Losing it reduces A by 4 and Z by 2.', T.nuc);
add('When a nucleus emits a beta (beta-minus) particle, its atomic number:', 'Rises by 1 and the mass number is unchanged', ['Falls by 1 and the mass number is unchanged', 'Falls by 2 and the mass number falls by 4', 'Is unchanged and the mass number rises by 1'],
  'A neutron changes into a proton and an electron. The electron leaves as the beta particle, so Z rises by 1 while A stays the same.', T.nuc);
add('Uranium-238 (Z = 92) undergoes alpha decay. The daughter nuclide is:', 'Thorium-234', ['Thorium-236', 'Protactinium-234', 'Radium-234'],
  'A falls by 4 (238 to 234) and Z falls by 2 (92 to 90). Element 90 is thorium, so the product is 234Th.', T.nuc);
add('The radioactive decay series starting from uranium-235 ends in a stable isotope of:', 'Lead-207', ['Lead-206', 'Lead-208', 'Bismuth-209'],
  'The actinium (uranium-235) series ends at stable lead-207. The uranium-238 series ends at lead-206 and the thorium-232 series ends at lead-208.', T.ser);

// ---------------- mass defect and binding energy
add('Mass defect is the difference between:', 'The sum of the masses of the separate nucleons and the mass of the nucleus', ['The mass of a proton and the mass of an electron', 'The mass of an atom and its atomic number', 'The mass numbers of two isotopes'],
  'The mass of a nucleus is always less than the total mass of its separate protons and neutrons. The difference is the mass defect, and it appears as the binding energy that holds the nucleus together.', T.bind);
add('The binding energy of a nucleus is related to its mass defect by:', 'E = delta m x c^2', ['E = delta m / c^2', 'E = delta m x c', 'E = delta m + c^2'],
  "Einstein's relation: the energy equivalent of a mass delta m is E = delta m c^2, where c is the speed of light.", T.bind);
{ const dm = 2 * 1.007825 + 2 * 1.008665 - 4.002603, be = dm * 931.5; chk(be, 28.30, 0.05);
  add('Calculate the binding energy of helium-4. (Atomic mass of 1H = 1.007825 u, mass of neutron = 1.008665 u, atomic mass of 4He = 4.002603 u; 1 u = 931.5 MeV)', '28.3 MeV', ['7.07 MeV', '56.6 MeV', '14.2 MeV'],
    'Step 1: Mass of 2 hydrogen atoms + 2 neutrons = 2(1.007825) + 2(1.008665) = 4.032980 u.\nStep 2: Mass defect = 4.032980 - 4.002603 = 0.030377 u.\nStep 3: Binding energy = 0.030377 x 931.5 = 28.3 MeV.', T.bind); }
{ chk(28.30 / 4, 7.07, 0.02);
  add('Helium-4 has a binding energy of 28.3 MeV. What is its binding energy per nucleon?', '7.07 MeV', ['28.3 MeV', '14.2 MeV', '113 MeV'],
    'Binding energy per nucleon = total binding energy / mass number = 28.3 / 4 = 7.07 MeV.', T.bind); }
add('A nucleus with a larger binding energy per nucleon is:', 'More stable', ['Less stable', 'Always radioactive', 'Always lighter'],
  'The larger the binding energy per nucleon, the more tightly the nucleons are held and the more stable the nucleus. Iron-56 is near the peak of the curve.', T.bind);

// ---------------- applications
add('Radiocarbon dating is used to estimate the age of:', 'Plant and animal remains', ['Igneous rocks billions of years old', 'Metal alloys', 'Fresh water'],
  'Carbon-14 is taken in by living things and stops being replaced when they die. Its decay (half-life 5730 years) is used to date organic material up to about 50 000 years old.', T.app);
add('Which radioisotope is used to diagnose and treat disorders of the thyroid gland?', 'Iodine-131', ['Cobalt-60', 'Sodium-24', 'Carbon-14'],
  'The thyroid takes up iodine. Iodine-131 is used to locate thyroid problems and, in larger doses, to treat thyroid disorders and tumours.', T.app);
add('Cobalt-60 is used in industry to:', 'Detect cracks and flaws in metal parts such as pipes and welded joints', ['Date rocks', 'Trace the flow of blood', 'Produce hydrogen'],
  'Its penetrating gamma rays pass through metal and expose a film, like an X-ray, and show cracks and flaws in pipes, aircraft parts and welded joints. It is also used in cancer radiotherapy.', T.app);
add('Sodium-24 is injected into the blood stream in order to:', 'Trace the flow of blood and locate an obstruction in the circulatory system', ['Date ancient bones', 'Treat thyroid cancer', 'Detect cracks in welds'],
  'The radiation from sodium-24 can be detected outside the body, so a doctor can follow it through the blood vessels and find blockages.', T.app);
add('Neutron activation analysis is used to:', 'Detect and measure trace elements and impurities in a sample', ['Date wood from trees', 'Measure the pH of a solution', 'Produce electricity'],
  'The sample is bombarded with neutrons, which make the trace elements radioactive. The characteristic radiation they emit is measured to identify and measure them.', T.app);
add('Radioactive tracers are used to study reaction mechanisms because:', 'The labelled atoms can be followed through the reaction by their radiation', ['They speed up the reaction', 'They lower the activation energy', 'They remove impurities'],
  'A radioactive isotope behaves chemically like the stable isotope of the same element, so it can be located in the products to show which atoms moved where.', T.app);

module.exports = out;
