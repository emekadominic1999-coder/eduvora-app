// CHM 102 (General Chemistry II) - second hand-set batch. Topics that had little or no coverage in the bank:
// aromatic hydrocarbons, petroleum, phenols, esters, carbohydrates, amino acids and proteins, integrated rate laws and
// half-life, elemental analysis calculations, chromatography and purification, functional-group tests, and the basic
// reactions of alkanes, alkenes and alkynes.
const L = require('../sta/lib');
const { add, out } = L;
const T = {
  aro: 'Aromatic Hydrocarbons', huc: 'Aromatic Character and Hückel Rule', rxb: 'Reactions of Benzene', pet: 'Petroleum', phe: 'Phenols', est: 'Esters',
  cho: 'Carbohydrates', aa: 'Amino Acids and Proteins', irl: 'Integrated Rate Equations and Half-Life', ext: 'Extraction of Tin and Lead',
  g14: 'Group 14 Oxides and Reactions', emp: 'Empirical and Molecular Formulae', ela: 'Elemental Analysis of Organic Compounds',
  pur: 'Chromatography and Purification', tst: 'Tests for Functional Groups', alk: 'Alkanes', ale: 'Alkenes', aly: 'Alkynes',
};
const chk = (a, b, tol = 1e-6) => { if (Math.abs(a - b) > tol) throw new Error('check failed ' + a + ' vs ' + b); };

// ---------------- aromatic hydrocarbons
add('The molecular formula of benzene is:', 'C₆H₆', ['C₆H₁₂', 'C₆H₁₄', 'C₅H₆'], 'Benzene has six carbon atoms and six hydrogen atoms in a planar ring.', T.aro);
add('All the carbon-carbon bonds in benzene are:', 'Equal in length, intermediate between single and double bonds', ['Alternately single and double', 'All double bonds', 'All single bonds'], 'The six π electrons are delocalised round the ring, so no bond is purely single or purely double.', T.aro);
add('The carbon atoms in benzene are:', 'sp² hybridised', ['sp hybridised', 'sp³ hybridised', 'sp³d hybridised'], 'Each carbon forms three σ bonds in a plane and contributes one p electron to the delocalised π system.', T.aro);
add('The shape of the benzene molecule is:', 'Planar hexagon', ['Tetrahedral', 'Chair-shaped', 'Linear'], 'All twelve atoms lie in one plane.', T.aro);
add('Which of the following is a natural source of aromatic hydrocarbons?', 'Coal tar', ['Limestone', 'Sea water', 'Granite'], 'Destructive distillation of coal gives coal tar, which contains benzene, toluene and naphthalene.', T.aro);
add('The IUPAC name of C₆H₅CH₃ is:', 'Methylbenzene', ['Benzyl alcohol', 'Phenol', 'Cyclohexane'], 'It is commonly called toluene.', T.aro);
add('The compound C₆H₅NO₂ is named:', 'Nitrobenzene', ['Aniline', 'Phenol', 'Benzoic acid'], 'A nitro group is attached directly to the benzene ring.', T.aro);
add('In a disubstituted benzene, the para positions are numbered:', '1 and 4', ['1 and 2', '1 and 3', '1 and 5'], 'Ortho is 1,2; meta is 1,3; para is 1,4.', T.aro);
add('1,3-dimethylbenzene is also called:', 'meta-xylene', ['ortho-xylene', 'para-xylene', 'toluene'], 'Substituents at positions 1 and 3 are in the meta arrangement.', T.aro);
add('The group C₆H₅– is called:', 'Phenyl', ['Benzyl', 'Benzoyl', 'Phenol'], 'It is formed by removing one hydrogen atom from benzene.', T.aro);
add('The group C₆H₅CH₂– is called:', 'Benzyl', ['Phenyl', 'Toluyl', 'Cyclohexyl'], 'A CH₂ group sits between the ring and the point of attachment.', T.aro);
add('Naphthalene has the molecular formula:', 'C₁₀H₈', ['C₁₀H₁₀', 'C₆H₆', 'C₁₂H₁₀'], 'It is made of two fused benzene rings.', T.aro);
add('Benzene is hazardous mainly because it is:', 'Carcinogenic', ['Radioactive', 'Strongly acidic', 'Explosive when dissolved in water'], 'Inhalation and skin contact should be avoided.', T.aro);
add('Aromatic hydrocarbons burn in air with a smoky flame because:', 'They have a high carbon content', ['They contain oxygen', 'They contain nitrogen', 'They are ionic'], 'The high proportion of carbon means combustion is incomplete in air and soot forms.', T.aro);

// ---------------- aromaticity
add('By Hückel\'s rule, a planar cyclic conjugated compound is aromatic if it has:', '4n + 2 π electrons', ['4n π electrons', '2n π electrons', 'An even number of σ bonds'], 'Where n = 0, 1, 2, 3, …', T.huc);
add('How many π electrons are in an aromatic ring with n = 2 in the 4n + 2 rule?', '10', ['6', '8', '14'], '4(2) + 2 = 10.', T.huc);
chk(4 * 2 + 2, 10);
add('Benzene obeys Hückel\'s rule because it has:', '6 π electrons (n = 1)', ['4 π electrons (n = 1)', '8 π electrons (n = 2)', '3 π electrons'], '4(1) + 2 = 6.', T.huc);
chk(4 * 1 + 2, 6);
add('Which condition is NOT required for a compound to be aromatic?', 'It must contain a halogen', ['It must be cyclic', 'It must be approximately planar', 'It must have a continuous system of overlapping p orbitals'], 'Halogens are irrelevant to aromaticity.', T.huc);
add('Benzene undergoes substitution rather than addition because:', 'Addition would destroy the stable delocalised π system', ['It has no π electrons', 'It has only single bonds', 'It is ionic'], 'In substitution the aromatic ring is restored at the end of the reaction.', T.huc);
add('The "aromatic sextet" refers to:', 'The six delocalised π electrons of the benzene ring', ['Six hydrogen atoms in benzene', 'Six carbon-hydrogen bonds', 'Six double bonds'], 'Each of the six carbon atoms contributes one p electron.', T.huc);

// ---------------- reactions of benzene
add('The reagents for the nitration of benzene are:', 'Concentrated HNO₃ and concentrated H₂SO₄', ['Dilute HNO₃ only', 'HCl and ZnCl₂', 'NaOH and heat'], 'The mixture produces the nitronium ion, which attacks the ring.', T.rxb);
add('The product of nitrating benzene is:', 'Nitrobenzene', ['Aniline', 'Phenol', 'Cyclohexane'], 'C₆H₆ + HNO₃ → C₆H₅NO₂ + H₂O.', T.rxb);
add('The catalyst for the chlorination of benzene to give chlorobenzene is:', 'FeCl₃', ['Nickel', 'Platinum', 'UV light only'], 'A Lewis acid catalyst is needed for the substitution to occur.', T.rxb);
add('Benzene reacts with fuming sulphuric acid to form:', 'Benzenesulphonic acid', ['Nitrobenzene', 'Phenol', 'Benzoic acid'], 'C₆H₆ + H₂SO₄ ⇌ C₆H₅SO₃H + H₂O.', T.rxb);
add('The Friedel-Crafts alkylation of benzene with CH₃Cl in the presence of AlCl₃ gives:', 'Methylbenzene', ['Chlorobenzene', 'Phenol', 'Nitrobenzene'], 'C₆H₆ + CH₃Cl → C₆H₅CH₃ + HCl.', T.rxb);
add('The Friedel-Crafts acylation of benzene with CH₃COCl and AlCl₃ gives:', 'Phenylethanone (acetophenone)', ['Methylbenzene', 'Ethylbenzene', 'Benzoic acid'], 'An acyl group is introduced, giving an aromatic ketone.', T.rxb);
add('The complete hydrogenation of benzene gives:', 'Cyclohexane', ['Hexane', 'Hex-1-ene', 'Cyclohexene'], 'C₆H₆ + 3H₂ → C₆H₁₂ with Ni, heat and pressure.', T.rxb);
add('The balanced equation for the complete combustion of benzene is:', '2C₆H₆ + 15O₂ → 12CO₂ + 6H₂O', ['C₆H₆ + 6O₂ → 6CO₂ + 3H₂O', '2C₆H₆ + 9O₂ → 12CO₂ + 6H₂O', 'C₆H₆ + 3O₂ → 6CO + 3H₂O'], 'Count oxygen: 12 × 2 + 6 = 30 atoms, so 15 molecules of O₂.', T.rxb);
chk(12 * 2 + 6, 15 * 2);
add('The characteristic reactions of benzene are:', 'Electrophilic substitution reactions', ['Nucleophilic addition reactions', 'Free-radical polymerisations', 'Elimination reactions'], 'The delocalised π cloud is attacked by electrophiles.', T.rxb);
add('Benzene does not decolourise bromine water because:', 'Its delocalised ring resists addition under ordinary conditions', ['It is soluble in water', 'It contains no carbon', 'It is a metal'], 'Alkenes decolourise bromine water by addition; benzene does not.', T.rxb);

// ---------------- petroleum
add('Petroleum is formed from:', 'The remains of microscopic organisms subjected to heat and pressure over millions of years', ['The reaction of limestone with acid', 'Volcanic ash only', 'Plant starch in the presence of oxygen'], 'The process takes place in the absence of oxygen.', T.pet);
add('Crude petroleum consists mainly of:', 'Alkanes', ['Alkynes', 'Carboxylic acids', 'Metal oxides'], 'Cycloalkanes, aromatics and small amounts of sulphur and nitrogen compounds are also present.', T.pet);
add('Crude oil is separated into fractions by:', 'Fractional distillation', ['Filtration', 'Crystallisation', 'Sublimation'], 'The fractions differ in boiling point.', T.pet);
add('In a fractionating column, the fractions with the highest boiling points are drawn off:', 'Near the bottom', ['Near the top', 'Only at the middle', 'Outside the column'], 'The column is hottest at the bottom, so heavy fractions condense there.', T.pet);
add('Which fraction of petroleum has the lowest boiling range?', 'Refinery gases (LPG)', ['Kerosene', 'Diesel', 'Bitumen'], 'The C₁–C₄ gases boil below about 30 °C.', T.pet);
add('The residue left at the bottom of the fractionating column is:', 'Bitumen', ['Petrol', 'Naphtha', 'Refinery gas'], 'Bitumen (above C₇₀) is used for road surfacing and roofing.', T.pet);
add('Kerosene is mainly used as:', 'Aviation fuel and for heating and lighting', ['Road surfacing', 'Plastic feedstock only', 'Fuel for spark-ignition cars only'], 'Its carbon range is about C₁₀–C₁₆.', T.pet);
add('Naphtha is important mainly because it is:', 'A feedstock for the petrochemical industry', ['A solid lubricant', 'Used only for tarring roads', 'A gas used in cooking'], 'It is used to make plastics and other chemicals.', T.pet);
add('Cracking of petroleum is:', 'The breakdown of large hydrocarbon molecules into smaller, more useful ones', ['Joining small molecules into polymers', 'Separating crude oil by boiling point', 'Removing sulphur by washing'], 'It is done by heat, often with a catalyst.', T.pet);
add('Which is the correct equation for a cracking reaction?', 'C₁₀H₂₂ → C₈H₁₈ + C₂H₄', ['C₁₀H₂₂ → C₈H₁₈ + C₂H₆', 'C₁₀H₂₂ → C₈H₁₄ + C₂H₈', 'C₁₀H₂₂ → C₅H₁₂ + C₂H₄'], 'The atoms balance: C 8 + 2 = 10 and H 18 + 4 = 22.', T.pet);
chk(8 + 2, 10); chk(18 + 4, 22);
add('A product of cracking that is a raw material for making plastics is:', 'An alkene such as ethene', ['An alkane such as methane', 'Carbon dioxide', 'Water'], 'Cracking produces alkenes.', T.pet);
add('Catalytic cracking uses catalysts such as:', 'Silica or alumina', ['Sodium chloride', 'Iron(III) oxide only', 'Calcium carbonate'], 'These allow cracking at a lower temperature than thermal cracking.', T.pet);
add('The octane rating of petrol measures:', 'Its resistance to knocking in a spark-ignition engine', ['Its colour', 'Its boiling point', 'Its sulphur content'], 'Higher octane means greater resistance to knocking.', T.pet);
add('On the octane scale, iso-octane is assigned a value of:', '100', ['0', '50', '10'], 'n-Heptane is assigned 0.', T.pet);
add('A petrol with an octane rating of 90 behaves like a mixture of:', '90% iso-octane and 10% n-heptane', ['10% iso-octane and 90% n-heptane', '90% n-heptane and 10% water', '50% iso-octane and 50% n-heptane'], 'The rating is the percentage of iso-octane in the reference mixture.', T.pet);
add('The cetane number measures:', 'The ignition quality of diesel fuel', ['The knocking resistance of petrol', 'The sulphur content of kerosene', 'The density of bitumen'], 'A higher cetane number means a shorter ignition delay.', T.pet);
add('The reference compound assigned a cetane number of 100 is:', 'Cetane (hexadecane)', ['Iso-octane', 'n-Heptane', 'Benzene'], 'Alpha-methylnaphthalene is assigned 0.', T.pet);

// ---------------- phenols
add('A phenol differs from an alcohol because in a phenol the –OH group is attached to:', 'A carbon atom of an aromatic ring', ['A saturated carbon atom', 'A carbonyl group', 'A nitrogen atom'], 'Phenol is C₆H₅OH.', T.phe);
add('The reagent that gives a violet colour with phenol is:', 'Neutral iron(III) chloride', ['Bromine in tetrachloromethane', 'Tollens\' reagent', 'Lucas reagent'], 'It is the standard test for a phenolic –OH group.', T.phe);
add('Phenol reacts with bromine water to give:', 'A white precipitate of 2,4,6-tribromophenol', ['A yellow solution of bromophenol only', 'No reaction', 'Phenyl bromide gas'], 'C₆H₅OH + 3Br₂ → C₆H₂Br₃OH + 3HBr.', T.phe);
add('Phenol reacts with sodium hydroxide to form:', 'Sodium phenoxide and water', ['Benzene and sodium oxide', 'Cyclohexanol', 'Sodium benzoate'], 'C₆H₅OH + NaOH → C₆H₅ONa + H₂O, showing that phenol is weakly acidic.', T.phe);
add('Phenol reacts with sodium metal to release:', 'Hydrogen gas', ['Oxygen gas', 'Carbon dioxide', 'Chlorine'], '2C₆H₅OH + 2Na → 2C₆H₅ONa + H₂.', T.phe);
add('Phenol may turn pink or brown on standing in air because of:', 'Oxidation', ['Reduction', 'Hydrolysis', 'Neutralisation'], 'Impure phenol oxidises slowly.', T.phe);
add('Phenol can be prepared by warming benzene diazonium chloride with:', 'Water', ['Concentrated sulphuric acid', 'Ethanol only', 'Sodium chloride'], 'C₆H₅N₂Cl + H₂O → C₆H₅OH + N₂ + HCl.', T.phe);
add('A phenol with two –OH groups on the ring is called:', 'Dihydric', ['Monohydric', 'Trihydric', 'Primary'], 'The classification depends on the number of hydroxyl groups.', T.phe);
add('Which is a use of phenol?', 'Manufacture of resins and plastics', ['Fuel for jet engines', 'Food sweetener', 'Making road bitumen'], 'It is also used for pharmaceuticals and dyes.', T.phe);

// ---------------- esters and carboxylic acid derivatives
add('The functional group of an ester is:', '–COO–', ['–CONH₂', '–COCl', '–CHO'], 'It joins an acyl part to an alkyl or aryl group.', T.est);
add('The ester CH₃COOC₂H₅ is named:', 'Ethyl ethanoate', ['Methyl propanoate', 'Ethyl methanoate', 'Ethanoic anhydride'], 'The alkyl group on oxygen is ethyl; the acid-derived part is ethanoate.', T.est);
add('The name of HCOOCH₃ is:', 'Methyl methanoate', ['Ethyl methanoate', 'Methyl ethanoate', 'Methanoic acid'], 'It is derived from methanoic acid and methanol.', T.est);
add('The ester C₆H₅COOCH₃ is named:', 'Methyl benzoate', ['Benzyl ethanoate', 'Phenyl ethanoate', 'Methyl phenylamine'], 'Benzoic acid gives benzoate esters.', T.est);
add('Esterification is the reaction between:', 'A carboxylic acid and an alcohol in the presence of concentrated sulphuric acid', ['An aldehyde and a ketone', 'An alkene and a halogen', 'Two alcohols and sodium'], 'RCOOH + R\'OH ⇌ RCOOR\' + H₂O.', T.est);
add('The product of the reaction between ethanoic acid and ethanol is:', 'Ethyl ethanoate and water', ['Ethanal and water', 'Diethyl ether only', 'Ethanoyl chloride'], 'CH₃COOH + C₂H₅OH ⇌ CH₃COOC₂H₅ + H₂O.', T.est);
add('Alkaline hydrolysis of an ester is called:', 'Saponification', ['Esterification', 'Polymerisation', 'Hydrogenation'], 'RCOOR\' + NaOH → RCOONa + R\'OH.', T.est);
add('The products of the alkaline hydrolysis of ethyl ethanoate with NaOH are:', 'Sodium ethanoate and ethanol', ['Ethanoic acid and ethanol', 'Ethanal and sodium', 'Sodium ethoxide and methanol'], 'The acid part leaves as its sodium salt.', T.est);
add('Many esters of low molecular mass are used in perfumes and flavourings because they have:', 'Pleasant fruity odours', ['Very high melting points', 'Strong acidity', 'Intense colour'], 'They are volatile liquids with sweet smells.', T.est);
add('Esters have lower boiling points than carboxylic acids of similar mass because esters:', 'Cannot hydrogen-bond with each other as donors', ['Are ionic', 'Have no oxygen', 'Contain metals'], 'They have no O–H group.', T.est);
add('Reduction of an ester with LiAlH₄ gives:', 'Two alcohols', ['A ketone and water', 'An aldehyde and an acid', 'An alkane'], 'RCOOR\' is reduced to RCH₂OH and R\'OH.', T.est);
add('Reaction of an ester with ammonia gives:', 'An amide and an alcohol', ['An amine and water', 'A nitrile and hydrogen', 'A carboxylic acid and nitrogen'], 'RCOOR\' + NH₃ → RCONH₂ + R\'OH.', T.est);
add('The reaction RCOOH + SOCl₂ → RCOCl + SO₂ + HCl is used to prepare:', 'Acyl chlorides', ['Esters', 'Amides', 'Nitriles'], 'Thionyl chloride replaces the –OH of the acid with –Cl.', T.est);
add('An acid anhydride is formed by:', 'The dehydration of two molecules of a carboxylic acid', ['The hydrolysis of an ester', 'The oxidation of an alcohol', 'The reduction of an amide'], '2RCOOH → (RCO)₂O + H₂O.', T.est);
add('The hydrolysis of ethanoyl chloride with water gives:', 'Ethanoic acid and hydrogen chloride', ['Ethanol and chlorine', 'Ethyl ethanoate', 'Ethanamide'], 'RCOCl + H₂O → RCOOH + HCl.', T.est);

// ---------------- carbohydrates
add('Carbohydrates are best described as:', 'Polyhydroxy aldehydes or ketones, or substances that give them on hydrolysis', ['Long chain hydrocarbons', 'Compounds of carbon and nitrogen only', 'Esters of fatty acids'], 'Many follow the general formula Cₓ(H₂O)ᵧ.', T.cho);
add('Glucose is classified as:', 'An aldohexose', ['A ketohexose', 'An aldopentose', 'A disaccharide'], 'It has six carbons and an aldehyde group.', T.cho);
add('Fructose is a:', 'Ketohexose', ['Aldohexose', 'Disaccharide', 'Polysaccharide'], 'It contains a ketone group.', T.cho);
add('The molecular formula of glucose is:', 'C₆H₁₂O₆', ['C₁₂H₂₂O₁₁', 'C₆H₁₀O₅', 'C₅H₁₀O₅'], 'Fructose is an isomer of the same formula.', T.cho);
add('Which of the following is a disaccharide?', 'Sucrose', ['Glucose', 'Starch', 'Cellulose'], 'Sucrose hydrolyses to glucose and fructose.', T.cho);
add('Lactose, the sugar of milk, hydrolyses to give:', 'Glucose and galactose', ['Glucose and fructose', 'Two molecules of glucose', 'Fructose and ribose'], 'It is a disaccharide of two different monosaccharides.', T.cho);
add('Which of the following is a polysaccharide that stores energy in animals?', 'Glycogen', ['Cellulose', 'Sucrose', 'Fructose'], 'It is stored in the liver and muscles.', T.cho);
add('Cellulose is important because it:', 'Provides structural support in plant cell walls', ['Stores energy in the liver', 'Is a simple sugar in fruit', 'Is the sugar in milk'], 'It is a polysaccharide of glucose units.', T.cho);
add('Starch serves mainly as:', 'The energy-storage carbohydrate of plants', ['The structural material of animals', 'A hormone', 'A vitamin'], 'It is found in seeds and tubers.', T.cho);
add('Glucose reduces Tollens\' reagent because it contains:', 'An aldehyde group in its open-chain form', ['A carboxyl group', 'An ether linkage', 'A nitrile group'], 'A silver mirror forms.', T.cho);
add('Warming glucose with Fehling\'s solution gives:', 'A brick-red precipitate of copper(I) oxide', ['A blue solution unchanged', 'A silver mirror', 'A white precipitate of AgCl'], 'The aldehyde group reduces Cu²⁺ to Cu₂O.', T.cho);
add('Reduction of glucose with hydrogen and a nickel catalyst gives:', 'Sorbitol', ['Gluconic acid', 'Ethanol', 'Sucrose'], 'The aldehyde group is reduced to an alcohol.', T.cho);
add('The formation of glucose pentaacetate on treatment with acetic anhydride shows that glucose has:', 'Five hydroxyl groups', ['Five carbonyl groups', 'Five double bonds', 'Five nitrogen atoms'], 'Each –OH group is acetylated.', T.cho);
add('Yeast fermentation of glucose produces:', 'Ethanol and carbon dioxide', ['Methanol and oxygen', 'Ethanoic acid and hydrogen', 'Sorbitol and water'], 'C₆H₁₂O₆ → 2C₂H₅OH + 2CO₂.', T.cho);
add('Mild oxidation of glucose with bromine water gives:', 'Gluconic acid', ['Sorbitol', 'Saccharic acid only', 'Glucose pentaacetate'], 'Only the aldehyde group is oxidised.', T.cho);
add('A hexose has how many carbon atoms?', '6', ['3', '5', '12'], 'Trioses have 3, pentoses 5 and hexoses 6.', T.cho);
add('The linkage joining two monosaccharides in a disaccharide is the:', 'Glycosidic bond', ['Peptide bond', 'Ester bond', 'Hydrogen bond'], 'It forms by loss of water between two sugar units.', T.cho);

// ---------------- amino acids and proteins
add('The general structure of an α-amino acid is:', 'NH₂–CH(R)–COOH', ['NH₂–CH₂–CH₂–OH', 'R–CO–NH₂', 'R–C≡N'], 'It has an amino group and a carboxyl group on the same carbon.', T.aa);
add('The simplest amino acid, in which R is H, is:', 'Glycine', ['Alanine', 'Valine', 'Lysine'], 'Alanine has a methyl side chain.', T.aa);
add('Which of these is an acidic amino acid?', 'Aspartic acid', ['Glycine', 'Lysine', 'Alanine'], 'It has a second carboxyl group in its side chain.', T.aa);
add('Which of these is a basic amino acid?', 'Lysine', ['Glutamic acid', 'Glycine', 'Valine'], 'Its side chain carries an extra amino group.', T.aa);
add('A zwitterion is:', 'An ion carrying both a positive and a negative charge in the same molecule', ['A positively charged metal ion', 'A neutral hydrocarbon', 'A free radical'], 'In an amino acid it is ⁺H₃N–CHR–COO⁻.', T.aa);
add('Essential amino acids are those that:', 'Must be obtained from the diet', ['The body makes in large amounts', 'Contain no nitrogen', 'Occur only in plants'], 'The body cannot make them in sufficient quantity.', T.aa);
add('The peptide bond is:', '–CO–NH–', ['–COO–', '–C≡N', '–O–'], 'It joins amino acids in proteins.', T.aa);
add('Formation of a peptide bond between two amino acids is a:', 'Condensation reaction with loss of water', ['Combustion', 'Addition with no by-product', 'Hydrogenation'], 'Amino acid + amino acid → dipeptide + H₂O.', T.aa);
add('The primary structure of a protein is:', 'The sequence of amino acids in the polypeptide chain', ['The α-helix', 'The arrangement of several chains', 'The folding of one chain into a three-dimensional shape'], 'Higher levels of structure depend on it.', T.aa);
add('The α-helix and β-pleated sheet are examples of:', 'Secondary structure', ['Primary structure', 'Tertiary structure', 'Quaternary structure'], 'They are stabilised by hydrogen bonds.', T.aa);
add('Haemoglobin, made of four polypeptide subunits, is an example of:', 'Quaternary structure', ['Primary structure', 'Secondary structure only', 'A carbohydrate'], 'Quaternary structure is the arrangement of multiple chains.', T.aa);
add('Collagen and keratin are examples of:', 'Fibrous proteins', ['Globular proteins', 'Conjugated carbohydrates', 'Lipids'], 'They are mainly structural.', T.aa);
add('Enzymes and haemoglobin are generally:', 'Globular proteins', ['Fibrous proteins', 'Polysaccharides', 'Nucleotides'], 'They are compact and functional.', T.aa);
add('Denaturation of a protein is:', 'The loss of its three-dimensional structure by heat, extreme pH or certain chemicals', ['The hydrolysis of every peptide bond', 'The formation of new peptide bonds', 'The oxidation of its carbohydrate'], 'The primary structure usually remains intact.', T.aa);
add('The biuret test for proteins gives:', 'A violet colour', ['A brick-red precipitate', 'A silver mirror', 'A yellow precipitate of iodoform'], 'It detects peptide bonds.', T.aa);
add('The Strecker synthesis of an α-amino acid starts from:', 'An aldehyde, ammonia and hydrogen cyanide', ['An alkene and bromine', 'An ester and water', 'A phenol and iron(III) chloride'], 'An aminonitrile forms first and is then hydrolysed.', T.aa);
add('Complete hydrolysis of a protein gives:', 'Amino acids', ['Monosaccharides', 'Fatty acids', 'Ethanol'], 'Protein → peptides → amino acids.', T.aa);
add('A simple protein is one that:', 'Yields only amino acids on hydrolysis', ['Contains a carbohydrate group', 'Contains a metal only', 'Has no peptide bonds'], 'Albumin is an example.', T.aa);
add('Glycoproteins and nucleoproteins are examples of:', 'Conjugated proteins', ['Simple proteins', 'Fibrous carbohydrates', 'Fats'], 'They contain a non-protein component.', T.aa);

// ---------------- alkanes
add('The general formula of the alkanes is:', 'CₙH₂ₙ₊₂', ['CₙH₂ₙ', 'CₙH₂ₙ₋₂', 'CₙHₙ'], 'Alkanes are saturated hydrocarbons.', T.alk);
add('Alkanes are relatively unreactive because they contain:', 'Strong C–C and C–H single bonds', ['Delocalised electrons', 'Triple bonds', 'Free halogen atoms'], 'They have no π bonds.', T.alk);
add('Which of these is NOT a natural source of alkanes?', 'Sea water', ['Natural gas', 'Crude petroleum', 'Biogas'], 'Natural gas is mainly methane.', T.alk);
add('Biogas is produced by:', 'Anaerobic decomposition of organic matter', ['Cracking of petrol', 'Combustion of coal', 'Hydration of ethene'], 'The main product is methane.', T.alk);
add('The boiling points of straight-chain alkanes:', 'Increase with molecular mass', ['Decrease with molecular mass', 'Are all equal', 'Fall to zero for the heavier members'], 'Stronger dispersion forces act between larger molecules.', T.alk);
add('Among isomers of the same alkane, the one with the lowest boiling point is the:', 'Most branched isomer', ['Straight-chain isomer', 'Isomer with the longest chain', 'One with the most carbon atoms'], 'Branching reduces the surface area and so the intermolecular forces.', T.alk);
add('Alkanes are insoluble in water because they are:', 'Non-polar', ['Ionic', 'Strongly acidic', 'Heavier than water'], 'They dissolve in non-polar solvents.', T.alk);
add('Heating sodium ethanoate with soda lime gives:', 'Methane', ['Ethane', 'Ethanol', 'Ethene'], 'CH₃COONa + NaOH → CH₄ + Na₂CO₃, one carbon fewer than the acid salt.', T.alk);
add('Catalytic hydrogenation of ethene gives:', 'Ethane', ['Ethyne', 'Ethanol', 'Methane'], 'CH₂=CH₂ + H₂ → CH₃CH₃ with a nickel catalyst.', T.alk);
add('The reaction of methane with chlorine in ultraviolet light is a:', 'Free-radical substitution', ['Nucleophilic addition', 'Electrophilic addition', 'Condensation'], 'CH₄ + Cl₂ → CH₃Cl + HCl.', T.alk);
add('The complete combustion of methane produces:', 'Carbon dioxide and water', ['Carbon monoxide and hydrogen', 'Carbon and nitrogen', 'Methanol only'], 'CH₄ + 2O₂ → CO₂ + 2H₂O.', T.alk);
add('Incomplete combustion of alkanes in a limited supply of oxygen may produce:', 'Carbon monoxide or soot', ['Only carbon dioxide', 'Only hydrogen', 'Only water'], 'Carbon monoxide is a poisonous gas.', T.alk);

// ---------------- alkenes
add('The general formula of an alkene with one double bond is:', 'CₙH₂ₙ', ['CₙH₂ₙ₊₂', 'CₙH₂ₙ₋₂', 'CₙH₂ₙ₊₁'], 'Ethene is C₂H₄.', T.ale);
add('Alkenes are more reactive than alkanes because the π bond:', 'Is weaker and more exposed than a σ bond', ['Is stronger than a σ bond', 'Does not exist', 'Is ionic'], 'It readily undergoes addition reactions.', T.ale);
add('Ethene can be prepared by heating ethanol with:', 'Concentrated sulphuric acid at about 170 °C', ['Dilute hydrochloric acid at 20 °C', 'Sodium at room temperature', 'Aqueous sodium hydroxide'], 'The alcohol is dehydrated.', T.ale);
add('Heating bromoethane with alcoholic KOH gives:', 'Ethene', ['Ethanol', 'Ethane', 'Ethyne'], 'CH₃CH₂Br + KOH → CH₂=CH₂ + KBr + H₂O.', T.ale);
add('Partial hydrogenation of an alkyne with Lindlar\'s catalyst gives:', 'An alkene', ['An alkane', 'An alcohol', 'An alkyl halide'], 'The reaction stops at the alkene stage.', T.ale);
add('Which reagent is used to test for unsaturation in an alkene?', 'Bromine water', ['Fehling\'s solution', 'Neutral FeCl₃', 'Sodium hydrogencarbonate'], 'The brown colour of bromine is decolourised.', T.ale);
add('The addition of bromine to ethene gives:', '1,2-dibromoethane', ['Bromoethane', '1,1-dibromoethane', 'Ethanol'], 'CH₂=CH₂ + Br₂ → CH₂Br–CH₂Br.', T.ale);
add('Hydration of ethene in the presence of an acid catalyst gives:', 'Ethanol', ['Ethanal', 'Ethanoic acid', 'Ethane'], 'CH₂=CH₂ + H₂O → CH₃CH₂OH.', T.ale);
add('The addition of HBr to propene gives mainly:', '2-bromopropane', ['1-bromopropane', '1,2-dibromopropane', 'Propane'], 'Markovnikov\'s rule: hydrogen adds to the carbon that already has more hydrogen atoms.', T.ale);
add('Cold, dilute, alkaline KMnO₄ converts an alkene into:', 'A diol', ['A ketone only', 'An alkane', 'A nitrile'], 'The purple colour is decolourised.', T.ale);
add('Polymerisation of ethene gives:', 'Polyethene', ['Polystyrene', 'PVC', 'Nylon'], 'n CH₂=CH₂ → –(CH₂–CH₂)ₙ–.', T.ale);
add('Geometric (cis-trans) isomerism in alkenes arises because of:', 'Restricted rotation about the double bond', ['Free rotation about the double bond', 'The presence of a halogen', 'Hydrogen bonding'], 'Different groups on each carbon give two arrangements.', T.ale);

// ---------------- alkynes
add('The general formula of the alkynes is:', 'CₙH₂ₙ₋₂', ['CₙH₂ₙ', 'CₙH₂ₙ₊₂', 'CₙH₂ₙ₊₁'], 'Ethyne is C₂H₂.', T.aly);
add('Ethyne can be prepared in the laboratory by the action of water on:', 'Calcium carbide', ['Calcium carbonate', 'Sodium chloride', 'Calcium oxide'], 'CaC₂ + 2H₂O → C₂H₂ + Ca(OH)₂.', T.aly);
add('The product of the complete hydrogenation of ethyne is:', 'Ethane', ['Ethene', 'Methane', 'Ethanol'], 'HC≡CH + 2H₂ → CH₃CH₃.', T.aly);
add('The product of adding one mole of HCl to ethyne is:', 'Chloroethene (vinyl chloride)', ['Chloroethane', '1,1-dichloroethane', 'Ethanal'], 'HC≡CH + HCl → CH₂=CHCl.', T.aly);
add('Ethyne burns in oxygen to give a very hot flame used for:', 'Welding and cutting', ['Water purification', 'Cooking rice only', 'Making plastics directly'], 'Oxy-acetylene torches reach very high temperatures.', T.aly);
add('The balanced equation for the combustion of ethyne is:', '2C₂H₂ + 5O₂ → 4CO₂ + 2H₂O', ['C₂H₂ + 2O₂ → 2CO₂ + H₂O', '2C₂H₂ + 3O₂ → 4CO + 2H₂O', 'C₂H₂ + O₂ → 2C + H₂O'], 'Oxygen: 4 × 2 + 2 = 10 atoms, so 5 molecules.', T.aly);
chk(4 * 2 + 2, 5 * 2);
add('Terminal alkynes react with sodamide (NaNH₂) to give:', 'A sodium acetylide and ammonia', ['An alkene and nitrogen', 'A nitrile and hydrogen', 'An alcohol and sodium'], 'The terminal hydrogen is weakly acidic.', T.aly);
add('Which of these hydrocarbons has the terminal hydrogen that can be removed by a strong base?', 'Propyne', ['Propene', 'Propane', 'But-2-yne'], 'Only a terminal alkyne has a hydrogen on the triply bonded carbon.', T.aly);
add('The double dehydrohalogenation of a vicinal dihaloalkane with strong base (such as KOH) gives:', 'An alkyne', ['An alkene', 'An alkane', 'An alcohol'], 'Two molecules of hydrogen halide are removed.', T.aly);

// ---------------- Group 14, extraction
add('Silicon is extracted from silicon(IV) oxide by reduction with:', 'Carbon in an electric furnace', ['Water', 'Hydrochloric acid', 'Sodium chloride'], 'SiO₂ + 2C → Si + 2CO.', T.ext);
add('The principal ore of tin is:', 'Cassiterite (SnO₂)', ['Galena', 'Bauxite', 'Haematite'], 'It is reduced with carbon in a furnace.', T.ext);
add('The principal ore of lead is:', 'Galena (PbS)', ['Cassiterite', 'Rutile', 'Dolomite'], 'It is concentrated by froth flotation.', T.ext);
add('In the extraction of lead, galena is first:', 'Roasted in air to give lead(II) oxide', ['Dissolved in water', 'Electrolysed in solution', 'Heated with sodium'], '2PbS + 3O₂ → 2PbO + 2SO₂.', T.ext);
add('The reduction step in the extraction of lead is represented by:', 'PbO + C → Pb + CO', ['2PbS + 3O₂ → 2PbO + 2SO₂', 'Pb + 2KOH → K₂PbO₂ + H₂', 'PbO + H₂O → Pb(OH)₂'], 'Carbon removes oxygen from the oxide.', T.ext);
add('The reduction of cassiterite is represented by:', 'SnO₂ + 2C → Sn + 2CO', ['SnO₂ + H₂O → Sn(OH)₂', 'Sn + O₂ → SnO₂', 'SnO₂ + 2HCl → SnCl₂ + H₂O'], 'The crude tin is then refined.', T.ext);
add('Froth flotation is used to:', 'Concentrate an ore', ['Reduce an oxide', 'Refine crude tin', 'Roast a sulphide'], 'It separates the mineral from the unwanted rock.', T.ext);
add('Tin is mainly used in:', 'Solder and protective coatings for steel cans', ['Making semiconductors', 'Pencil leads', 'Diamond cutting tools'], 'Lead is used in lead-acid batteries and radiation shielding.', T.ext);
add('Which element of Group 14 is used in semiconductors and computer chips?', 'Silicon', ['Lead', 'Tin', 'Carbon as diamond'], 'It is also used in solar cells.', T.ext);
add('Carbon monoxide is formed when carbon burns in:', 'A limited supply of oxygen', ['Excess oxygen', 'Water', 'A vacuum with no oxygen at all'], '2C + O₂ → 2CO.', T.g14);
add('Carbon dioxide is formed when carbon burns in:', 'Excess oxygen', ['A limited supply of oxygen', 'Hydrogen', 'Nitrogen'], 'C + O₂ → CO₂.', T.g14);
add('Tin dissolves in hot concentrated potassium hydroxide because tin is:', 'Amphoteric', ['Inert', 'A non-metal', 'Strongly basic'], 'It forms a stannate with the alkali.', T.g14);
add('The oxide of Group 14 that is acidic and gaseous at room temperature is:', 'CO₂', ['SiO₂', 'SnO₂', 'PbO'], 'SiO₂ is acidic but solid; SnO₂ and PbO are amphoteric.', T.g14);

// ---------------- integrated rate equations, half-life
add('For a first-order reaction the half-life is:', 'Independent of the initial concentration', ['Proportional to the initial concentration', 'Inversely proportional to the initial concentration', 'Always zero'], 't½ = 0.693 / k.', T.irl);
add('The half-life of a reaction with first-order rate constant k = 0.0231 min⁻¹ is:', '30 min', ['3 min', '0.016 min', '300 min'], 't½ = 0.693 / 0.0231 = 30 min.', T.irl);
chk(0.693 / 0.0231, 30, 1e-9);
add('A first-order reaction has a half-life of 20 minutes. Its rate constant is about:', '0.0347 min⁻¹', ['0.0035 min⁻¹', '0.347 min⁻¹', '13.9 min⁻¹'], 'k = 0.693 / 20 = 0.03465 min⁻¹.', T.irl);
chk(0.693 / 20, 0.03465, 1e-5);
add('For a first-order reaction, the fraction of reactant remaining after three half-lives is:', '1/8 (12.5%)', ['1/3', '1/6', '1/4'], 'Each half-life halves the concentration: (1/2)³ = 1/8.', T.irl);
chk(0.5 ** 3, 0.125);
add('The integrated rate equation of a first-order reaction is:', 'ln([A]₀/[A]) = kt', ['[A] = [A]₀ – kt', '1/[A] = 1/[A]₀ + kt', '[A] = kt'], 'A plot of ln[A] against t is a straight line of slope –k.', T.irl);
add('For a zero-order reaction, the integrated rate equation is:', '[A] = [A]₀ – kt', ['ln[A] = ln[A]₀ – kt', '1/[A] = 1/[A]₀ + kt', '[A] = [A]₀ e^(kt)'], 'The concentration falls linearly with time.', T.irl);
add('The half-life of a zero-order reaction with [A]₀ = 0.80 M and k = 0.020 M s⁻¹ is:', '20 s', ['40 s', '10 s', '0.8 s'], 't½ = [A]₀ / 2k = 0.80 / 0.040 = 20 s.', T.irl);
chk(0.80 / (2 * 0.020), 20, 1e-9);
add('The half-life of a second-order reaction with [A]₀ = 0.20 M and k = 0.50 M⁻¹ s⁻¹ is:', '10 s', ['2 s', '20 s', '0.1 s'], 't½ = 1 / (k[A]₀) = 1 / (0.50 × 0.20) = 10 s.', T.irl);
chk(1 / (0.50 * 0.20), 10, 1e-9);
add('For a second-order reaction, a plot of 1/[A] against time gives a straight line whose slope is:', 'k', ['–k', 'ln k', '[A]₀'], '1/[A] = 1/[A]₀ + kt.', T.irl);
add('A first-order reaction has k = 0.0462 min⁻¹. The time for the concentration to fall from 0.80 M to 0.20 M is about:', '30 min', ['15 min', '60 min', '3 min'], 't = ln(0.80/0.20)/k = ln 4 / 0.0462 = 1.386 / 0.0462 ≈ 30 min.', T.irl);
chk(Math.log(4) / 0.0462, 30, 0.1);
add('The units of the rate constant of a first-order reaction are:', 's⁻¹', ['M s⁻¹', 'M⁻¹ s⁻¹', 'M² s⁻¹'], 'Rate (M s⁻¹) = k [A], so k has units of s⁻¹.', T.irl);
add('The units of the rate constant of a second-order reaction are:', 'M⁻¹ s⁻¹', ['s⁻¹', 'M s⁻¹', 'M² s⁻¹'], 'Rate = k [A]² gives M s⁻¹ = k M², so k = M⁻¹ s⁻¹.', T.irl);
add('The units of the rate constant of a zero-order reaction are:', 'M s⁻¹', ['s⁻¹', 'M⁻¹ s⁻¹', 'Dimensionless'], 'Rate = k, so k has the units of rate.', T.irl);

// ---------------- empirical and molecular formulae, elemental analysis
add('A compound contains 54.5% C, 9.1% H and 36.4% O by mass. Its empirical formula is:', 'C₂H₄O', ['CH₂O', 'C₂H₆O', 'C₃H₆O₂'], 'Moles: C 4.54, H 9.1, O 2.275. Dividing by 2.275 gives 2 : 4 : 1.', T.emp);
chk(54.5 / 12 / (36.4 / 16), 2, 0.01); chk(9.1 / (36.4 / 16), 4, 0.01);
add('The compound in the previous question has molar mass 88 g mol⁻¹. Its molecular formula is:', 'C₄H₈O₂', ['C₂H₄O', 'C₈H₁₆O₄', 'C₃H₆O₂'], 'The empirical formula mass is 44, so n = 88 / 44 = 2.', T.emp);
chk(88 / 44, 2);
add('A compound has empirical formula CH₂O and molar mass 180 g mol⁻¹. Its molecular formula is:', 'C₆H₁₂O₆', ['C₃H₆O₃', 'C₁₂H₂₄O₁₂', 'C₅H₁₀O₅'], 'The empirical formula mass is 30, so n = 180 / 30 = 6.', T.emp);
chk(180 / 30, 6);
add('Combustion of 0.50 g of an organic compound gave 1.10 g CO₂ and 0.45 g H₂O. The percentage of carbon is:', '60.0%', ['30.0%', '22.0%', '45.0%'], '%C = (12/44) × (1.10/0.50) × 100 = 60.0%.', T.ela);
chk((12 / 44) * (1.10 / 0.50) * 100, 60.0, 1e-9);
add('For the same sample (0.50 g giving 1.10 g CO₂ and 0.45 g H₂O), the percentage of hydrogen is:', '10.0%', ['5.0%', '9.0%', '20.0%'], '%H = (2/18) × (0.45/0.50) × 100 = 10.0%.', T.ela);
chk((2 / 18) * (0.45 / 0.50) * 100, 10.0, 1e-9);
add('If the compound above contains only C, H and O, the percentage of oxygen is:', '30.0%', ['40.0%', '70.0%', '10.0%'], '%O = 100 – (60.0 + 10.0) = 30.0%.', T.ela);
chk(100 - (60 + 10), 30);
add('In Kjeldahl\'s method, a 0.50 g sample requires 20.0 mL of 0.10 N acid for the ammonia produced. Using %N = 1.4 NV/W, the percentage of nitrogen is:', '5.6%', ['2.8%', '11.2%', '0.56%'], '%N = 1.4 × 0.10 × 20.0 / 0.50 = 5.6%.', T.ela);
chk(1.4 * 0.10 * 20.0 / 0.50, 5.6, 1e-9);
add('In Dumas\' method, a 0.200 g sample gives 1.00 × 10⁻³ mol of N₂. The percentage of nitrogen is:', '14.0%', ['7.0%', '28.0%', '1.4%'], 'Mass of N = 28 × 1.00 × 10⁻³ = 0.028 g; %N = 0.028 / 0.200 × 100 = 14.0%.', T.ela);
chk(28 * 1e-3 / 0.200 * 100, 14, 1e-9);
add('In Carius\' method, 0.30 g of a chlorine-containing organic compound gives 0.50 g of AgCl. The percentage of chlorine is about (Cl = 35.45, AgCl = 143.32):', '41.2%', ['24.7%', '82.4%', '20.6%'], '%Cl = (35.45 / 143.32) × (0.50 / 0.30) × 100 ≈ 41.2%.', T.ela);
chk((35.45 / 143.32) * (0.50 / 0.30) * 100, 41.2, 0.05);
add('Lassaigne\'s test is used to detect:', 'Nitrogen, sulphur and the halogens in an organic compound', ['Only carbon', 'Only oxygen', 'The molar mass'], 'Fusion with sodium converts them into ionic sodium salts.', T.ela);
add('In Lassaigne\'s test, carbon and nitrogen in the compound form:', 'Sodium cyanide', ['Sodium carbonate only', 'Ammonia gas', 'Sodium nitrate'], 'Na + C + N → NaCN.', T.ela);
add('The organic nitrogen in Kjeldahl\'s method is first converted into:', 'Ammonium sulphate', ['Nitrogen gas', 'Nitric acid', 'Sodium nitrate'], 'Digestion with concentrated sulphuric acid and a catalyst converts it.', T.ela);

// ---------------- chromatography, purification, functional-group tests
add('In thin-layer chromatography, a spot travels 3.6 cm while the solvent front travels 6.0 cm. The Rf value is:', '0.60', ['1.67', '0.36', '2.4'], 'Rf = 3.6 / 6.0 = 0.60.', T.pur);
chk(3.6 / 6.0, 0.60, 1e-9);
add('The Rf value of a compound in thin-layer chromatography is always:', 'Between 0 and 1', ['Greater than 1', 'Negative', 'Equal to the molar mass'], 'A spot cannot move farther than the solvent front.', T.pur);
add('Iodine vapour is used in thin-layer chromatography to:', 'Make colourless spots visible', ['Dissolve the plate', 'Increase the Rf value', 'Neutralise the solvent'], 'The spots stain brown or yellow-brown.', T.pur);
add('The starting line on a TLC plate should be drawn with a:', 'Pencil', ['Ball-point pen', 'Marker pen', 'Permanent ink'], 'Pencil graphite does not dissolve in the solvent.', T.pur);
add('A volatile liquid decomposes at 60 °C but boils at 90 °C at atmospheric pressure. It should be purified by:', 'Vacuum distillation', ['Simple distillation at normal pressure', 'Heating to 100 °C', 'Sublimation'], 'Lowering the pressure lowers the boiling point below the decomposition temperature.', T.pur);
add('Naphthalene can be purified from non-volatile impurities by:', 'Sublimation', ['Filtration only', 'Steam distillation of salt', 'Electrolysis'], 'It changes directly from solid to vapour on heating.', T.pur);
add('Two miscible liquids with boiling points close together are separated by:', 'Fractional distillation', ['Simple filtration', 'Crystallisation', 'Decantation'], 'Repeated vaporisation and condensation in the column is needed.', T.pur);
add('Steam distillation is suitable for substances that are:', 'Volatile with steam and immiscible with water', ['Highly soluble in water', 'Involatile', 'Ionic'], 'Essential oils are often purified this way.', T.pur);
add('Crystallisation is used to purify:', 'Solids, based on differences in solubility', ['Gases', 'Metals by electrolysis', 'Liquids by boiling point'], 'The solid crystallises from a cooled saturated solution.', T.pur);
add('Which reagent distinguishes an aldehyde from a ketone by giving a silver mirror?', 'Tollens\' reagent', ['2,4-DNPH', 'Bromine water', 'Neutral FeCl₃'], 'Aldehydes reduce the silver complex to silver; ketones do not.', T.tst);
add('2,4-Dinitrophenylhydrazine gives a yellow or orange precipitate with:', 'Aldehydes and ketones', ['Alcohols only', 'Alkenes', 'Carboxylic acids'], 'It detects the carbonyl group.', T.tst);
add('A carboxylic acid is detected by adding sodium hydrogencarbonate, which gives:', 'Effervescence of carbon dioxide', ['A silver mirror', 'A violet colour', 'A brick-red precipitate'], 'RCOOH + NaHCO₃ → RCOONa + H₂O + CO₂.', T.tst);
add('The Lucas test distinguishes alcohols according to:', 'Their class as primary, secondary or tertiary', ['Their molar mass only', 'The presence of a double bond', 'Their colour'], 'Tertiary alcohols give turbidity almost immediately; primary alcohols do not react at room temperature.', T.tst);
add('The iodoform test is positive for:', 'Methyl ketones such as propanone', ['All ketones', 'All aldehydes', 'Ethers'], 'A yellow precipitate of CHI₃ forms.', T.tst);
add('Fehling\'s solution gives a brick-red precipitate with:', 'Aliphatic aldehydes', ['Ketones', 'Alkanes', 'Phenols'], 'The precipitate is copper(I) oxide.', T.tst);
add('The hydroxamic acid test is used to detect:', 'Esters', ['Alkenes', 'Alcohols', 'Amines'], 'A reddish-purple colour forms with Fe³⁺.', T.tst);

module.exports = out;
