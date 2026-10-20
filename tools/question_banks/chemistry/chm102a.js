// CHM 102 (General Chemistry II) - hand-set questions on the outline topics that had little or no coverage:
// nitriles, aldehydes, ketones, alcohols, ethers, amines, determination of structure, chemical kinetics, nomenclature.
const L = require('../sta/lib');
const { add, out } = L;
const T = {
  nom: 'Nomenclature and Functional Groups', kin: 'Chemical Kinetics', det: 'Determination of Structures of Organic Compounds', nit: 'Nitriles', ald: 'Aldehydes', ket: 'Ketones',
  alc: 'Alcohols', eth: 'Ethers', ami: 'Amines', intro: 'Introductory Organic Chemistry',
};
const chk = (a, b, tol = 1e-6) => { if (Math.abs(a - b) > tol) throw new Error('check failed ' + a + ' vs ' + b); };

// ---------------- nomenclature and functional groups
add('The IUPAC name of CH3CH2CH(CH3)CH2OH is:', '2-methylbutan-1-ol', ['3-methylbutan-1-ol', '2-ethylpropan-1-ol', '3-methylbutan-4-ol'], 'The longest chain containing the OH group has four carbons and is numbered from the OH end. The methyl group is on carbon 2.', T.nom);
add('The functional group in propanone, CH3COCH3, is:', 'Carbonyl group in a ketone', ['Aldehyde group', 'Hydroxyl group', 'Ester group'], 'The carbonyl carbon is joined to two carbon atoms, so the compound is a ketone.', T.nom);
add('Which of the following pairs are functional group isomers?', 'Ethanol and methoxymethane', ['Butane and 2-methylpropane', 'Propan-1-ol and propan-2-ol', 'Pent-1-ene and pent-2-ene'], 'Both have the formula C2H6O, but one is an alcohol and the other an ether.', T.nom);
add('The compound CH3CH2CHO is named:', 'Propanal', ['Propanone', 'Propan-1-ol', 'Propanoic acid'], 'The suffix -al is used for an aldehyde, and the chain has three carbons.', T.nom);
add('The compound CH3COCH2CH3 is named:', 'Butanone', ['Butanal', 'Butan-2-ol', 'Propanone'], 'The carbonyl group is on carbon 2 of a four-carbon chain, so the name is butan-2-one or butanone.', T.nom);
add('The IUPAC name of CH3CH2OCH2CH3 is:', 'Ethoxyethane', ['Diethyl alcohol', 'Butan-1-ol', 'Methoxypropane'], 'Ethers are named as alkoxyalkanes, with the shorter group as the alkoxy prefix.', T.nom);
add('The IUPAC name of CH3CH2CH2NH2 is:', 'Propan-1-amine', ['Propanamide', 'Propan-1-ol', 'N-methylethanamine'], 'The suffix -amine is used for the -NH2 group on a three-carbon chain.', T.nom);
add('The IUPAC name of (CH3)2NH is:', 'N-methylmethanamine', ['Dimethylethanamine', 'Ethanamine', 'Methanamide'], 'It is a secondary amine with two methyl groups on nitrogen.', T.nom);
add('The IUPAC name of CH3CN is:', 'Ethanenitrile', ['Methanenitrile', 'Ethanamide', 'Acetylamine'], 'The carbon of the CN group is counted in the chain, so two carbons give ethanenitrile.', T.nom);
add('The IUPAC name of CH3CH(OH)CH3 is:', 'Propan-2-ol', ['Propan-1-ol', 'Propanol-3', 'Isopropane'], 'The OH is on the middle carbon of three.', T.nom);
add('The molecular formula CnH2n+1OH represents the general formula of:', 'Alkanols (alcohols)', ['Alkanals', 'Alkanones', 'Ethers'], 'Methanol, ethanol and propanol are members of this series.', T.nom);
add('The general formula CnH2nO fits:', 'Aldehydes and ketones', ['Alcohols and ethers', 'Carboxylic acids', 'Amines'], 'Propanal and propanone are both C3H6O, so they are isomers.', T.nom);
add('Which of these is a secondary alcohol?', 'Butan-2-ol', ['Butan-1-ol', '2-methylpropan-2-ol', 'Methanol'], 'The carbon bearing the OH group in butan-2-ol is bonded to two other carbon atoms.', T.nom);
add('Which of these is a tertiary alcohol?', '2-methylpropan-2-ol', ['Propan-2-ol', 'Butan-2-ol', 'Ethanol'], 'The carbon bearing the OH is attached to three carbon atoms.', T.nom);
add('The number of structural isomers of C4H10O that are alcohols is:', '4', ['2', '3', '6'], 'The alcohols are butan-1-ol, butan-2-ol, 2-methylpropan-1-ol and 2-methylpropan-2-ol.', T.nom);
add('The number of structural isomers of the formula C3H9N is:', '4', ['2', '3', '5'], 'They are propylamine, isopropylamine, ethylmethylamine and trimethylamine.', T.nom);
add('The homologous series with the functional group -COOR is that of:', 'Esters', ['Acid anhydrides', 'Amides', 'Ketones'], 'An ester is formed from a carboxylic acid and an alcohol.', T.nom);
add('A homologous series is a group of compounds that:', 'Have the same functional group and differ from each other by a CH2 unit', ['Have the same molecular formula', 'Contain only carbon and hydrogen', 'Have the same physical properties'], 'Members show a gradual change in physical properties and similar chemical properties.', T.nom);
add('The number of degrees of unsaturation in a compound of formula C6H12 is:', '1', ['0', '2', '4'], 'Degrees of unsaturation = (2C + 2 - H) ÷ 2 = (14 - 12) ÷ 2 = 1, which means one double bond or one ring.', T.det);
chk((2 * 6 + 2 - 12) / 2, 1);
add('Benzene, C6H6, has how many degrees of unsaturation?', '4', ['1', '2', '3'], '(2 × 6 + 2 - 6) ÷ 2 = 4: three C=C bonds and one ring.', T.det);
chk((2 * 6 + 2 - 6) / 2, 4);
add('The compound C4H8O has how many degrees of unsaturation?', '1', ['0', '2', '3'], '(2 × 4 + 2 - 8) ÷ 2 = 1. Oxygen does not change the count, and it could be a C=O or a ring.', T.det);
chk((2 * 4 + 2 - 8) / 2, 1);

// ---------------- alcohols
add('The boiling point of ethanol (78 °C) is much higher than that of methoxymethane (-24 °C), although both are C2H6O. This is because ethanol:', 'Forms hydrogen bonds between its molecules', ['Has a larger molar mass', 'Is a salt', 'Has a double bond'], 'The OH group allows hydrogen bonding, which needs much more energy to overcome than the dipole forces in the ether.', T.alc);
add('Why are methanol and ethanol completely miscible with water?', 'They form hydrogen bonds with water molecules', ['They are ionic', 'They are non-polar', 'They react with water to give acids'], 'The OH group can both donate and accept hydrogen bonds.', T.alc);
add('As the carbon chain of a straight-chain alcohol gets longer, its solubility in water:', 'Decreases', ['Increases', 'Stays the same', 'Becomes infinite'], 'The non-polar hydrocarbon part becomes larger compared with the polar OH group.', T.alc);
add('Ethanol is produced industrially by the hydration of:', 'Ethene with steam in the presence of a phosphoric acid catalyst', ['Ethane with chlorine', 'Methane with water', 'Ethyne with sodium'], 'CH2=CH2 + H2O → CH3CH2OH at about 300 °C and 60 to 70 atm.', T.alc);
add('Ethanol can be made from sugar by:', 'Fermentation with yeast', ['Cracking', 'Hydrolysis with acid only', 'Oxidation of methane'], 'Zymase in yeast converts glucose into ethanol and carbon dioxide.', T.alc);
add('Heating ethanol with excess concentrated sulphuric acid at 170 °C gives:', 'Ethene', ['Ethoxyethane', 'Ethanal', 'Ethanoic acid'], 'This is an elimination (dehydration) reaction.', T.alc);
add('Heating excess ethanol with concentrated sulphuric acid at 140 °C gives mainly:', 'Ethoxyethane', ['Ethene', 'Ethanal', 'Ethyl sulphate only'], 'At the lower temperature, one molecule of water is lost from two molecules of alcohol.', T.alc);
add('Oxidation of a primary alcohol with excess acidified potassium dichromate(VI) under reflux gives:', 'A carboxylic acid', ['A ketone', 'An alkene', 'An ether'], 'The primary alcohol is oxidised first to an aldehyde and then to the carboxylic acid.', T.alc);
add('To obtain an aldehyde from a primary alcohol, the oxidising agent is used with:', 'Distillation of the aldehyde as it forms', ['Reflux with excess oxidant', 'A strongly basic solution', 'Addition of sodium'], 'Distilling off the aldehyde prevents further oxidation to the acid.', T.alc);
add('Oxidation of a secondary alcohol such as propan-2-ol gives:', 'A ketone, propanone', ['An aldehyde', 'A carboxylic acid', 'An ester'], 'A secondary alcohol is oxidised to a ketone, which resists further oxidation.', T.alc);
add('Which type of alcohol is NOT easily oxidised by acidified potassium dichromate?', 'Tertiary alcohol', ['Primary alcohol', 'Secondary alcohol', 'Ethanol'], 'A tertiary alcohol has no hydrogen on the carbon bearing the OH group.', T.alc);
add('Which alcohol reacts immediately with Lucas reagent (concentrated HCl and ZnCl2) at room temperature?', '2-methylpropan-2-ol', ['Butan-1-ol', 'Butan-2-ol', 'Ethanol'], 'A tertiary alcohol forms a stable carbocation, so the alkyl chloride appears at once as a cloudy layer.', T.alc);
add('When sodium metal is added to ethanol, the gas evolved is:', 'Hydrogen', ['Oxygen', 'Carbon dioxide', 'Ethane'], 'The products are sodium ethoxide and hydrogen gas.', T.alc);
add('The reaction of an alcohol with a carboxylic acid in the presence of a little concentrated sulphuric acid forms:', 'An ester and water', ['An ether and water', 'An aldehyde', 'An alkene'], 'This reversible reaction is called esterification.', T.alc);
add('Ethanol and ethanoic acid react in the presence of acid catalyst to give:', 'Ethyl ethanoate', ['Methyl ethanoate', 'Ethyl methanoate', 'Ethanal'], 'CH3COOH + C2H5OH ⇌ CH3COOC2H5 + H2O.', T.alc);
add('Alcohols are weaker acids than water because:', 'The alkoxide ion is destabilised by the electron-releasing alkyl group', ['The O-H bond in alcohols is stronger than in water', 'Alcohols have no oxygen', 'Alkyl groups withdraw electrons'], 'The alkyl group pushes electron density onto oxygen, which makes the alkoxide a stronger base.', T.alc);
add('Reduction of a ketone with lithium aluminium hydride gives:', 'A secondary alcohol', ['A primary alcohol', 'A tertiary alcohol', 'An ether'], 'The C=O group is converted to CH-OH.', T.alc);
add('A primary alcohol is obtained by the reduction of:', 'An aldehyde', ['A ketone', 'An alkene', 'An alkyl halide'], 'Aldehyde RCHO + 2[H] → RCH2OH.', T.alc);
add('The reaction of a Grignard reagent with methanal (formaldehyde), followed by acid hydrolysis, gives:', 'A primary alcohol', ['A secondary alcohol', 'A tertiary alcohol', 'A ketone'], 'RMgX adds to H2C=O to give RCH2OMgX, which is hydrolysed to RCH2OH.', T.alc);
add('A tertiary alcohol is formed when a Grignard reagent reacts with:', 'A ketone, followed by hydrolysis', ['Methanal', 'An aldehyde', 'Carbon dioxide'], 'The new carbon-carbon bond makes the carbonyl carbon bear three carbon groups.', T.alc);
add('Which test distinguishes ethanol from methanol?', 'The iodoform test', ['Reaction with sodium', 'Reaction with acidified dichromate', 'Litmus paper'], 'Ethanol contains the CH3CH(OH)- unit and gives yellow iodoform, CHI3, with iodine and alkali. Methanol does not.', T.alc);
add('Propan-1-ol and propan-2-ol are best distinguished by:', 'Oxidising them and testing the products with Tollens\' reagent', ['Adding water', 'Measuring their molar masses', 'Burning them'], 'Propan-1-ol is oxidised to propanal, which gives a silver mirror. Propan-2-ol gives propanone, which does not.', T.alc);
add('The common name of propane-1,2,3-triol is:', 'Glycerol', ['Glycol', 'Phenol', 'Glucose'], 'It has three OH groups and is obtained from fats and oils.', T.alc);
add('Ethane-1,2-diol is used as:', 'Antifreeze in car radiators', ['A fuel in stoves', 'An anaesthetic', 'A detergent'], 'It lowers the freezing point of water.', T.alc);
add('Dehydration of butan-2-ol with concentrated sulphuric acid gives mainly:', 'But-2-ene, according to Saytzeff\'s rule', ['But-1-ene', 'Butane', 'Butanone'], 'The more substituted alkene is the major product.', T.alc);
add('Phenol is more acidic than ethanol because:', 'The phenoxide ion is stabilised by delocalisation of the negative charge into the ring', ['Ethanol is ionic', 'Phenol has a smaller molar mass', 'The OH bond is non-polar'], 'Resonance stabilises the phenoxide ion.', T.alc);
add('Methanol is poisonous because it is:', 'Oxidised in the body to methanal and methanoic acid, which can cause blindness', ['A strong acid', 'Converted to ethanol', 'Insoluble in water'], 'Ethanol is given as an antidote because it competes for the same enzyme.', T.alc);
add('The reaction of ethanol with PCl5 gives:', 'Chloroethane, hydrogen chloride and phosphorus oxychloride', ['Ethene and water', 'Ethanal', 'Ethoxyethane'], 'Steamy fumes of HCl are a test for the OH group.', T.alc);
add('Alcohols react with hydrogen halides to give:', 'Alkyl halides and water', ['Alkenes and halogens', 'Ethers only', 'Alkanes'], 'The order of reactivity of the hydrogen halides is HI > HBr > HCl.', T.alc);

// ---------------- ethers
add('Which of the following is an ether?', 'CH3OCH2CH3', ['CH3CH2OH', 'CH3COCH3', 'CH3COOCH3'], 'An ether has an oxygen atom bonded to two alkyl groups, R-O-R.', T.eth);
add('Ethers have much lower boiling points than isomeric alcohols because:', 'Ether molecules cannot form hydrogen bonds with each other', ['Ethers are ionic', 'Ethers have higher molar masses', 'Ethers have double bonds'], 'There is no O-H group in ethers.', T.eth);
add('The Williamson synthesis prepares ethers from:', 'An alkoxide and an alkyl halide', ['Two alkenes', 'An alcohol and an aldehyde', 'An alkane and oxygen'], 'The alkoxide ion attacks the alkyl halide by an SN2 reaction.', T.eth);
add('Ethoxyethane is made in the Williamson synthesis by reacting:', 'Sodium ethoxide with bromoethane', ['Sodium ethoxide with ethanol', 'Ethanal with ethanol', 'Sodium hydroxide with ethane'], 'C2H5ONa + C2H5Br → C2H5OC2H5 + NaBr.', T.eth);
add('Diethyl ether was once widely used as:', 'A general anaesthetic', ['An antifreeze', 'A food preservative', 'A fertiliser'], 'It is volatile and highly flammable, and has been replaced by safer anaesthetics.', T.eth);
add('Diethyl ether stored for long in contact with air can become dangerous because it:', 'Forms explosive peroxides', ['Turns into acid', 'Freezes', 'Becomes soluble in water'], 'Peroxides form slowly and can explode on heating.', T.eth);
add('Ethers are cleaved by refluxing with excess concentrated:', 'Hydroiodic acid, HI', ['Sodium hydroxide', 'Sodium chloride solution', 'Dilute ethanol'], 'HI cleaves the C-O bond to give alkyl iodides, or an alcohol and alkyl iodide.', T.eth);
add('Ethers are good solvents for organic reactions, such as Grignard reactions, because they:', 'Are fairly unreactive and can solvate the Grignard reagent', ['React vigorously with it', 'Are acidic', 'Are ionic'], 'The lone pairs on oxygen stabilise the magnesium centre.', T.eth);
add('An epoxide is:', 'A three-membered cyclic ether', ['A five-membered ring ketone', 'An open-chain aldehyde', 'A cyclic alkane'], 'Ethylene oxide is the simplest epoxide, and its ring is strained and reactive.', T.eth);
add('Ethers are:', 'Less reactive than alcohols and do not react with sodium', ['More reactive than alcohols', 'Acidic and react with sodium', 'Strongly basic'], 'They have no O-H hydrogen.', T.eth);
add('The compounds ethoxyethane and butan-1-ol are isomers. Which statement about them is correct?', 'Butan-1-ol has the higher boiling point', ['Ethoxyethane has the higher boiling point', 'They have the same boiling point', 'Neither can dissolve in water'], 'Butan-1-ol forms hydrogen bonds between molecules and ethoxyethane does not.', T.eth);

// ---------------- aldehydes
add('Aldehydes differ from ketones in having:', 'A hydrogen atom bonded to the carbonyl carbon', ['A hydroxyl group', 'Two alkyl groups on the carbonyl carbon', 'A carbon-carbon double bond'], 'The aldehyde group is -CHO.', T.ald);
add('The aldehyde with the common name formaldehyde is:', 'Methanal', ['Ethanal', 'Propanal', 'Methanol'], 'A 40% aqueous solution is called formalin, used to preserve biological specimens.', T.ald);
add('The common name of ethanal is:', 'Acetaldehyde', ['Formaldehyde', 'Acetone', 'Acetic acid'], 'It is made by oxidising ethanol.', T.ald);
add('Aldehydes can be prepared by:', 'Mild oxidation of primary alcohols', ['Oxidation of tertiary alcohols', 'Hydration of alkenes', 'Reduction of carboxylic acids with water'], 'The oxidising agent must not be too strong, so the aldehyde is distilled off as it forms.', T.ald);
add('Ozonolysis of 2-methylpropene (followed by reductive work-up) gives:', 'Methanal and propanone', ['Two molecules of ethanal', 'Propanal and methanal', 'Two molecules of propanone'], '(CH3)2C=CH2 is cleaved into (CH3)2C=O and H2C=O.', T.ald);
add('Which reagent gives a silver mirror with an aldehyde on warming?', 'Tollens\' reagent, [Ag(NH3)2]+', ['Fehling\'s solution', '2,4-dinitrophenylhydrazine', 'Iodine in alkali'], 'The aldehyde is oxidised to a carboxylate and silver ions are reduced to metallic silver.', T.ald);
add('Fehling\'s solution gives a brick-red precipitate with:', 'Aliphatic aldehydes such as ethanal', ['Ketones such as propanone', 'Alcohols', 'Alkenes'], 'The aldehyde reduces copper(II) ions to red copper(I) oxide.', T.ald);
add('Which compound does NOT reduce Tollens\' reagent?', 'Propanone', ['Methanal', 'Ethanal', 'Propanal'], 'Ketones are not easily oxidised and do not give a silver mirror.', T.ald);
add('The reagent used to test for the presence of a carbonyl group (aldehyde or ketone) is:', '2,4-dinitrophenylhydrazine (Brady\'s reagent)', ['Tollens\' reagent', 'Fehling\'s solution', 'Bromine water'], 'It gives an orange or yellow precipitate, a 2,4-dinitrophenylhydrazone.', T.ald);
add('The melting point of the 2,4-dinitrophenylhydrazone derivative is useful because:', 'It can be used to identify the original aldehyde or ketone', ['It shows the colour of the carbonyl compound', 'It gives the molar mass directly', 'It shows whether the compound is an acid'], 'Each carbonyl compound gives a derivative with a characteristic melting point.', T.ald);
add('The reaction of an aldehyde with hydrogen cyanide gives:', 'A cyanohydrin (hydroxynitrile)', ['An alcohol and nitrogen', 'A carboxylic acid', 'An amine'], 'CN- attacks the carbonyl carbon in a nucleophilic addition reaction.', T.ald);
add('The characteristic reaction of the carbonyl group in aldehydes is:', 'Nucleophilic addition', ['Electrophilic substitution', 'Free radical substitution', 'Elimination'], 'The carbonyl carbon is partially positive and is attacked by nucleophiles.', T.ald);
add('Aldehydes are generally more reactive than ketones toward nucleophiles because:', 'The carbonyl carbon in an aldehyde has less steric hindrance and less electron-donating alkyl groups', ['Aldehydes have more oxygen', 'Ketones contain no carbonyl group', 'Aldehydes are ionic'], 'Ketones have two alkyl groups that donate electrons and block the attack.', T.ald);
add('Which of these aldehydes gives the Cannizzaro reaction with concentrated alkali?', 'Methanal', ['Propanal', 'Ethanal', 'Butanal'], 'Aldehydes without an alpha hydrogen undergo disproportionation to an alcohol and a carboxylate.', T.ald);
add('The aldol condensation requires that the aldehyde has:', 'At least one alpha hydrogen', ['No hydrogen on the carbonyl carbon', 'A benzene ring', 'A double bond'], 'Dilute alkali removes the alpha hydrogen to form an enolate ion.', T.ald);
add('Two molecules of ethanal react in dilute alkali to give:', '3-hydroxybutanal (aldol)', ['Butanal', 'Ethanoic acid', 'Ethyl ethanoate'], 'The enolate of one ethanal adds to the carbonyl group of another.', T.ald);
add('Reduction of ethanal with sodium borohydride gives:', 'Ethanol', ['Ethanoic acid', 'Ethane', 'Ethene'], 'NaBH4 reduces aldehydes to primary alcohols.', T.ald);
add('Oxidation of propanal gives:', 'Propanoic acid', ['Propanone', 'Propan-1-ol', 'Propane'], 'Aldehydes are easily oxidised to carboxylic acids.', T.ald);
add('The boiling points of aldehydes are lower than those of alcohols of similar molar mass because:', 'Aldehyde molecules cannot form hydrogen bonds with each other', ['Aldehydes are ionic', 'Aldehydes have higher molar mass', 'Aldehydes have no oxygen'], 'They have only dipole-dipole interactions.', T.ald);
add('Aldehydes with fewer than about five carbon atoms are soluble in water because:', 'The carbonyl oxygen accepts hydrogen bonds from water', ['They are ionic', 'They are acids', 'They react with water to form alkenes'], 'Solubility falls as the hydrocarbon chain becomes longer.', T.ald);
add('Benzaldehyde has the formula:', 'C6H5CHO', ['C6H5COOH', 'C6H5CH2OH', 'C6H5COCH3'], 'It is the simplest aromatic aldehyde and smells of almonds.', T.ald);
add('Reaction of an aldehyde with an alcohol in dry acid gives:', 'An acetal', ['An ester', 'An ether only', 'An amide'], 'The carbonyl carbon ends up bonded to two OR groups.', T.ald);

// ---------------- ketones
add('Propanone is also called:', 'Acetone', ['Acetaldehyde', 'Formaldehyde', 'Acetic acid'], 'It is the simplest ketone and is used as a solvent, for example in nail polish remover.', T.ket);
add('Ketones are prepared by the oxidation of:', 'Secondary alcohols', ['Primary alcohols', 'Tertiary alcohols', 'Alkanes'], 'A secondary alcohol such as propan-2-ol is oxidised to propanone.', T.ket);
add('Hydration of propyne in the presence of dilute sulphuric acid and mercury(II) sulphate gives:', 'Propanone', ['Propanal', 'Propan-1-ol', 'Propanoic acid'], 'The enol first formed rearranges to the ketone.', T.ket);
add('Which reagent can be used to distinguish a ketone from an aldehyde?', 'Tollens\' reagent', ['2,4-dinitrophenylhydrazine', 'Brady\'s reagent', 'Sodium hydroxide'], 'Both give a precipitate with 2,4-DNPH, but only aldehydes give a silver mirror.', T.ket);
add('Which of these compounds gives a positive iodoform test?', 'Propanone', ['Propanal', 'Pentan-3-one', 'Methanal'], 'It contains the CH3CO- group.', T.ket);
add('The yellow precipitate formed in the iodoform test has the formula:', 'CHI3', ['CH3I', 'CI4', 'CH2I2'], 'Iodoform is a pale yellow solid with an antiseptic smell.', T.ket);
add('Which compound does NOT give a positive iodoform test?', 'Pentan-3-one', ['Ethanol', 'Propanone', 'Butan-2-ol'], 'Pentan-3-one has no CH3CO- group, and has no CH3CH(OH)- group.', T.ket);
add('Reduction of propanone with NaBH4 gives:', 'Propan-2-ol', ['Propan-1-ol', 'Propane', 'Propanal'], 'A ketone is reduced to a secondary alcohol.', T.ket);
add('The reaction of a ketone with hydrazine and a strong base at high temperature (Wolff-Kishner) converts C=O into:', 'CH2', ['CHOH', 'COOH', 'CH3'], 'The carbonyl group is completely reduced to a methylene group.', T.ket);
add('Ketones are less easily oxidised than aldehydes because:', 'They have no hydrogen atom on the carbonyl carbon', ['They have no oxygen', 'They are ionic', 'They contain double bonds'], 'Oxidation of a ketone requires breaking a carbon-carbon bond.', T.ket);
add('The boiling point of propanone (56 °C) is higher than that of butane (-1 °C) because propanone:', 'Has permanent dipole-dipole attractions', ['Forms hydrogen bonds', 'Is ionic', 'Has a lower molar mass'], 'The C=O bond is polar.', T.ket);
add('The compound CH3COCH2CH3 reacts with HCN to give:', 'A cyanohydrin, 2-hydroxy-2-methylbutanenitrile', ['Butanoic acid', 'Butan-2-ol', 'An imine'], 'CN- adds to the carbonyl carbon and the oxygen is protonated.', T.ket);
add('Which of the following can undergo an aldol reaction?', 'Propanone', ['Methanal', 'Benzaldehyde', '2,2-dimethylpropanal'], 'It has alpha hydrogens, while the other compounds have none.', T.ket);
add('Cyclohexanone is:', 'A cyclic ketone', ['A cyclic aldehyde', 'A cyclic ether', 'A cyclic alcohol'], 'The carbonyl carbon is part of the six-membered ring.', T.ket);
add('The reaction of a ketone with a primary amine forms:', 'An imine (Schiff base)', ['An amide', 'An ester', 'An acid'], 'Water is lost during the condensation.', T.ket);
add('Keto-enol tautomerism involves:', 'The migration of an alpha hydrogen to oxygen with movement of a double bond', ['The loss of the oxygen atom', 'A change of the carbon skeleton', 'The addition of water'], 'The keto form is usually much more stable than the enol form.', T.ket);
add('Which spectroscopic feature shows a ketone C=O group?', 'A strong IR absorption at about 1715 cm⁻¹', ['A broad band at 3300 cm⁻¹', 'A band at 2250 cm⁻¹', 'A band at 600 cm⁻¹ only'], 'The carbonyl stretch is one of the strongest and most characteristic IR absorptions.', T.ket);

// ---------------- nitriles
add('The functional group of a nitrile is:', '-C≡N', ['-NH2', '-NO2', '-N=C=O'], 'Nitriles have a carbon-nitrogen triple bond.', T.nit);
add('The carbon atom in the nitrile group is:', 'sp hybridised', ['sp2 hybridised', 'sp3 hybridised', 'unhybridised'], 'The linear C≡N unit uses an sp carbon.', T.nit);
add('Bromoethane reacts with potassium cyanide in ethanol (heated under reflux) to give:', 'Propanenitrile', ['Ethanenitrile', 'Ethanamine', 'Propanoic acid'], 'The CN- ion replaces Br- and adds one carbon to the chain.', T.nit);
add('The reaction of an alkyl halide with KCN is useful because it:', 'Lengthens the carbon chain by one carbon', ['Shortens the chain', 'Removes the halogen without changing the chain', 'Makes an alkene'], 'It is a nucleophilic substitution that forms a new C-C bond.', T.nit);
add('Complete hydrolysis of ethanenitrile by refluxing with dilute hydrochloric acid gives:', 'Ethanoic acid and ammonium chloride', ['Ethanamine', 'Ethanol and ammonia', 'Ethanal'], 'CH3CN + 2H2O + HCl → CH3COOH + NH4Cl.', T.nit);
add('Reduction of propanenitrile with lithium aluminium hydride gives:', 'Propan-1-amine', ['Propanamide', 'Propanoic acid', 'Propan-1-ol'], 'The C≡N group is reduced to CH2NH2.', T.nit);
add('Catalytic hydrogenation of a nitrile, RCN, gives:', 'A primary amine, RCH2NH2', ['A secondary amine', 'An amide', 'An alcohol'], 'The triple bond is saturated and each nitrogen bears two hydrogens.', T.nit);
add('Dehydration of ethanamide with phosphorus(V) oxide gives:', 'Ethanenitrile', ['Ethanoic acid', 'Ethylamine', 'Ethanal'], 'CH3CONH2 → CH3CN + H2O.', T.nit);
add('The reaction of a nitrile with a Grignard reagent followed by acid hydrolysis gives:', 'A ketone', ['An aldehyde', 'A carboxylic acid', 'An alcohol'], 'The Grignard reagent adds to the C≡N, and hydrolysis of the imine gives the ketone.', T.nit);
add('In its infrared spectrum, a nitrile shows a characteristic absorption near:', '2250 cm⁻¹', ['1700 cm⁻¹', '3300 cm⁻¹', '1050 cm⁻¹'], 'The C≡N stretch appears as a sharp medium-intensity band.', T.nit);
add('Benzonitrile has the formula:', 'C6H5CN', ['C6H5NH2', 'C6H5NO2', 'C6H5COOH'], 'It is made by heating benzenediazonium chloride with CuCN (Sandmeyer reaction) or from bromobenzene and CuCN.', T.nit);
add('Nitriles have higher boiling points than alkanes of similar molar mass because:', 'The C≡N group is strongly polar', ['They form hydrogen bonds with each other', 'They are ionic', 'They have double bonds'], 'Strong dipole-dipole attractions raise the boiling point.', T.nit);
add('Nitriles are named by adding "nitrile" to the name of the alkane with the same number of carbon atoms, counting:', 'The nitrile carbon as part of the chain', ['Only the carbons before the nitrile group', 'None of the carbons', 'Only branches'], 'CH3CH2CN has three carbons and is propanenitrile.', T.nit);
add('The hydrolysis of a nitrile in basic solution gives first the:', 'Carboxylate salt with release of ammonia', ['Alkene', 'Alcohol', 'Aldehyde'], 'Acidification then gives the carboxylic acid.', T.nit);

// ---------------- amines
add('Which of these is a primary amine?', 'CH3CH2NH2', ['(CH3)2NH', '(CH3)3N', 'CH3CONH2'], 'A primary amine has one alkyl group on the nitrogen.', T.ami);
add('Trimethylamine, (CH3)3N, is a:', 'Tertiary amine', ['Primary amine', 'Secondary amine', 'Quaternary ammonium salt'], 'Nitrogen is bonded to three alkyl groups and no hydrogen.', T.ami);
add('Amines act as bases because the nitrogen atom has:', 'A lone pair of electrons that can accept a proton', ['An empty orbital', 'A positive charge', 'A double bond'], 'RNH2 + H+ → RNH3+.', T.ami);
add('Which is the strongest base in water?', 'Ethylamine', ['Ammonia', 'Aniline', 'Ethanamide'], 'The electron-releasing ethyl group increases the electron density on nitrogen. Aniline is weakened by delocalisation into the ring.', T.ami);
add('Phenylamine (aniline) is a weaker base than ethylamine because:', 'The lone pair on nitrogen is delocalised into the benzene ring', ['It has more nitrogen atoms', 'The benzene ring donates electrons to nitrogen', 'It is an acid'], 'The lone pair is less available to accept a proton.', T.ami);
add('The boiling points of isomeric amines increase in the order:', 'Tertiary < secondary < primary', ['Primary < secondary < tertiary', 'Secondary < tertiary < primary', 'All have the same boiling point'], 'Primary amines have two N-H bonds for hydrogen bonding, and tertiary amines have none.', T.ami);
add('Why are lower amines soluble in water?', 'They form hydrogen bonds with water', ['They are ionic', 'They are acids', 'They are non-polar'], 'The nitrogen lone pair accepts hydrogen bonds from water and N-H donates them.', T.ami);
add('Ethylamine reacts with hydrochloric acid to give:', 'Ethylammonium chloride', ['Ethanol', 'Ethanamide', 'Ethane'], 'C2H5NH2 + HCl → C2H5NH3+ Cl-.', T.ami);
add('Primary amines are prepared by reaction of an alkyl halide with:', 'Excess ammonia in ethanol', ['Excess alkyl halide', 'Water', 'Sodium'], 'Excess ammonia reduces further alkylation to secondary and tertiary amines.', T.ami);
add('Heating bromoethane with a limited amount of ammonia gives a mixture of amines because:', 'The product amine is also a nucleophile and reacts with more bromoethane', ['Ammonia is acidic', 'Bromoethane is a gas', 'The reaction is not a substitution'], 'Successive substitution gives primary, secondary and tertiary amines and the quaternary salt.', T.ami);
add('Reduction of nitrobenzene with tin and concentrated hydrochloric acid gives:', 'Phenylamine (aniline)', ['Phenol', 'Benzoic acid', 'Benzaldehyde'], 'The NO2 group is reduced to NH2.', T.ami);
add('The reaction of a primary amine with nitrous acid at 0 to 5 °C is used for aromatic amines to form:', 'A diazonium salt', ['An amide', 'A nitrile', 'An ester'], 'Aromatic diazonium salts are stable only at low temperatures.', T.ami);
add('Benzenediazonium chloride couples with phenol in alkaline solution to give:', 'An orange or red azo dye', ['A white precipitate of benzene', 'A colourless solution', 'Nitrobenzene'], 'This coupling reaction forms the -N=N- azo group, which is a chromophore.', T.ami);
add('Amines react with acid chlorides to form:', 'Amides', ['Esters', 'Nitriles', 'Ethers'], 'RNH2 + R\'COCl → R\'CONHR + HCl.', T.ami);
add('The Hofmann bromamide reaction converts an amide into a primary amine with:', 'One carbon atom fewer', ['One carbon atom more', 'The same number of carbons', 'Two carbons more'], 'RCONH2 + Br2 + 4NaOH → RNH2 + 2NaBr + Na2CO3 + 2H2O.', T.ami);
add('Ethanamide on Hofmann degradation gives:', 'Methylamine', ['Ethylamine', 'Propylamine', 'Ammonia'], 'The amide carbon is lost as carbonate, so the product has one carbon.', T.ami);
add('The Hinsberg test is used to distinguish between:', 'Primary, secondary and tertiary amines', ['Aldehydes and ketones', 'Alcohols and ethers', 'Alkenes and alkynes'], 'It uses benzenesulphonyl chloride in alkali.', T.ami);
add('Amines have a characteristic smell like:', 'Rotten fish', ['Vinegar', 'Almonds', 'Bananas'], 'Trimethylamine is found in decaying fish.', T.ami);
add('A quaternary ammonium salt is an ammonium compound in which:', 'Nitrogen is bonded to four alkyl groups', ['Nitrogen is bonded to hydrogen only', 'There are two nitrogen atoms', 'There is a carbonyl group'], 'It has a permanent positive charge and is used in some detergents and disinfectants.', T.ami);
add('An amide is formed when an amine reacts with a:', 'Carboxylic acid derivative such as an acid chloride', ['Alcohol', 'Alkene', 'Ether'], 'Amides contain the -CONH- group.', T.ami);
add('Amino acids contain both an amino group and:', 'A carboxyl group', ['A hydroxyl group', 'A nitro group', 'An ether linkage'], 'In solution they exist as zwitterions.', T.ami);
add('The IR spectrum of a primary amine shows N-H stretching bands at about:', '3300 to 3500 cm⁻¹', ['1700 cm⁻¹', '2250 cm⁻¹', '1000 cm⁻¹'], 'Primary amines show two bands, and secondary amines show one.', T.ami);

// ---------------- determination of structures: elemental and formula work
add('The empirical formula of a compound with 40.0% C, 6.7% H and 53.3% O by mass is:', 'CH2O', ['C2H4O', 'C2H2O2', 'CHO'], 'Moles: C = 40.0/12 = 3.33, H = 6.7/1 = 6.7, O = 53.3/16 = 3.33. The ratio is 1 : 2 : 1.', T.det);
chk(40 / 12, 3.3333, 1e-3); chk(53.3 / 16, 3.3313, 1e-2);
add('The compound above has a relative molecular mass of 180. Its molecular formula is:', 'C6H12O6', ['C3H6O3', 'C4H8O4', 'C12H24O12'], 'The empirical formula mass of CH2O is 30, and 180 ÷ 30 = 6.', T.det);
chk(180 / 30, 6);
add('Combustion of 0.30 g of a hydrocarbon gives 0.88 g of carbon dioxide. The mass of carbon in the sample is:', '0.24 g', ['0.12 g', '0.30 g', '0.44 g'], 'Mass of C = 0.88 × 12/44 = 0.24 g.', T.det);
chk(0.88 * 12 / 44, 0.24);
add('In the hydrocarbon above, the mass of hydrogen is:', '0.06 g', ['0.24 g', '0.03 g', '0.12 g'], 'Mass of H = 0.30 - 0.24 = 0.06 g.', T.det);
chk(0.30 - 0.24, 0.06);
add('The empirical formula of the hydrocarbon above is:', 'CH3', ['CH', 'CH2', 'C2H3'], 'Moles: C = 0.24/12 = 0.02, H = 0.06/1 = 0.06, so the ratio is 1 : 3.', T.det);
chk(0.24 / 12, 0.02); chk(0.06, 0.06);
add('A compound contains 85.7% carbon and 14.3% hydrogen and has a molar mass of 56 g/mol. Its molecular formula is:', 'C4H8', ['CH2', 'C2H4', 'C5H10'], 'Empirical formula CH2 (mass 14). 56 ÷ 14 = 4, so the molecular formula is C4H8.', T.det);
chk(85.7 / 12 / (14.3 / 1), 0.4994, 1e-3); chk(56 / 14, 4);
add('Sodium fusion (Lassaigne\'s test) is used to detect:', 'Nitrogen, sulphur and halogens in an organic compound', ['Oxygen and hydrogen', 'Carbon only', 'The molar mass'], 'The elements are converted to ionic compounds that dissolve in water.', T.det);
add('In the Lassaigne test, the formation of Prussian blue colour indicates the presence of:', 'Nitrogen', ['Sulphur', 'Chlorine', 'Phosphorus'], 'Cyanide ions from the fusion form hexacyanoferrate(II) and then Prussian blue with Fe3+.', T.det);
add('A white precipitate that dissolves in dilute ammonia, formed when the sodium fusion extract is acidified and silver nitrate is added, shows:', 'Chlorine', ['Bromine', 'Iodine', 'Sulphur'], 'AgCl is soluble in dilute ammonia, AgBr is only slightly soluble, and AgI is insoluble.', T.det);
add('A yellow precipitate that is insoluble in ammonia with silver nitrate indicates:', 'Iodine', ['Chlorine', 'Bromine', 'Fluorine'], 'AgI is yellow and insoluble in ammonia.', T.det);
add('Carbon and hydrogen in an organic compound are detected qualitatively by heating with copper(II) oxide, which gives:', 'Carbon dioxide (turns limewater milky) and water (turns anhydrous copper sulphate blue)', ['Hydrogen and carbon monoxide', 'Nitrogen and oxygen', 'Ammonia and hydrogen chloride'], 'The CuO oxidises the carbon and hydrogen of the compound.', T.det);
add('Bromine water is decolourised quickly at room temperature by:', 'Alkenes', ['Alkanes', 'Benzene', 'Ethers'], 'The bromine adds across the C=C bond and the orange colour disappears.', T.det);
add('Acidified potassium manganate(VII) is decolourised by:', 'Unsaturated hydrocarbons, such as an alkene', ['Alkanes', 'Chloroalkanes', 'Water'], 'Purple MnO4- is reduced to almost colourless Mn2+.', T.det);
add('Effervescence with sodium hydrogen carbonate solution is a test for:', 'Carboxylic acids', ['Alcohols', 'Aldehydes', 'Ethers'], 'Carbon dioxide is evolved.', T.det);
add('Neutral iron(III) chloride solution gives a violet colour with:', 'Phenol', ['Ethanol', 'Propanone', 'Hexane'], 'It is a test for the phenolic OH group.', T.det);
add('A white precipitate that forms with ammoniacal silver nitrate on adding a terminal alkyne such as propyne confirms:', 'The presence of the ≡C-H group', ['The presence of C=C', 'A carboxylic acid', 'An alcohol'], 'The acidic hydrogen is replaced by silver.', T.det);
add('The purity of a solid organic compound is best checked by its:', 'Sharp melting point', ['Colour', 'Smell', 'Solubility in water only'], 'Impurities lower and broaden the melting range.', T.det);
add('Crystallisation is used to purify:', 'Solid organic compounds', ['Gases only', 'Miscible liquids with the same boiling point', 'Metals'], 'The impure solid is dissolved in a hot solvent, and the pure crystals form on cooling.', T.det);
add('Fractional distillation separates:', 'Miscible liquids with different boiling points', ['Immiscible liquids', 'Solids from liquids', 'Gases from solids'], 'The more volatile liquid is collected first.', T.det);
add('Steam distillation is used for compounds that:', 'Are immiscible with water, volatile in steam and decompose near their boiling point', ['Dissolve completely in water', 'Have very high melting points', 'Are gases'], 'It allows distillation at a temperature below 100 °C, as with essential oils.', T.det);
add('In paper chromatography, the Rf value is:', 'The distance moved by the spot divided by the distance moved by the solvent front', ['The distance moved by the solvent front divided by that of the spot', 'The time taken for the spot to move', 'The mass of the spot'], 'The value is always between 0 and 1 and is characteristic of a substance in a given solvent.', T.det);
add('A spot travels 3.0 cm while the solvent front travels 12.0 cm. The Rf value is:', '0.25', ['4.0', '0.75', '0.30'], 'Rf = 3.0 ÷ 12.0 = 0.25.', T.det);
chk(3 / 12, 0.25);

// ---------------- spectroscopy
add('In infrared spectroscopy, a broad strong absorption at 3200 to 3600 cm⁻¹ indicates:', 'An O-H group in an alcohol', ['A C=O group', 'A C≡N group', 'A C=C group'], 'Hydrogen bonding broadens the O-H stretch.', T.det);
add('A strong sharp absorption near 1700 cm⁻¹ in an IR spectrum indicates:', 'A carbonyl group, C=O', ['An O-H group', 'A C-H bond in alkanes', 'A C≡C bond'], 'It is found in aldehydes, ketones, acids and esters.', T.det);
add('A very broad O-H absorption from 2500 to 3300 cm⁻¹ together with a C=O at 1710 cm⁻¹ is typical of:', 'A carboxylic acid', ['An alcohol', 'A ketone', 'An ether'], 'The hydrogen-bonded acid dimer gives a very broad band.', T.det);
add('In the mass spectrum of an organic compound, the molecular ion peak M+ shows the:', 'Relative molecular mass of the compound', ['Number of carbon atoms only', 'Functional group directly', 'Boiling point'], 'The peak of highest m/z, apart from isotope peaks, gives the molar mass.', T.det);
add('The mass spectrum of a chloroalkane shows M and M+2 peaks in the ratio of about:', '3 : 1', ['1 : 1', '1 : 3', '2 : 1'], 'The natural abundance of 35Cl to 37Cl is about 3 to 1.', T.det);
add('A bromoalkane shows M and M+2 peaks in the ratio of about:', '1 : 1', ['3 : 1', '1 : 3', '2 : 1'], '79Br and 81Br are almost equally abundant.', T.det);
add('The compound with a molecular ion peak at m/z 58 and a strong IR peak at 1715 cm⁻¹ is most likely:', 'Propanone', ['Butane', 'Propan-1-ol', 'Ethanoic acid'], 'Propanone, CH3COCH3, has M = 58 and a ketone C=O stretch.', T.det);
chk(3 * 12 + 6 + 16, 58);
add('In proton NMR, the number of different signals in the spectrum equals the number of:', 'Sets of chemically different (non-equivalent) hydrogen atoms', ['Carbon atoms', 'All hydrogen atoms', 'Double bonds'], 'Equivalent hydrogens give a single signal.', T.det);
add('How many signals would you expect in the 1H NMR spectrum of ethanol, CH3CH2OH?', '3', ['1', '2', '6'], 'There are three environments: CH3, CH2 and OH.', T.det);
add('How many signals would you expect in the 1H NMR spectrum of propanone?', '1', ['2', '3', '6'], 'The six hydrogens are all equivalent.', T.det);
add('The aldehyde hydrogen, -CHO, typically appears in the 1H NMR spectrum at a chemical shift of about:', '9 to 10 ppm', ['0 to 1 ppm', '2 to 3 ppm', '5 to 6 ppm'], 'The hydrogen is strongly deshielded by the carbonyl group.', T.det);
add('The n + 1 rule predicts that a CH3 group next to a CH2 group appears as a:', 'Triplet', ['Singlet', 'Doublet', 'Quartet'], 'Two neighbouring hydrogens split the signal into 2 + 1 = 3 lines.', T.det);
add('The CH2 group of an ethyl group, CH3CH2-, appears as a:', 'Quartet', ['Triplet', 'Doublet', 'Singlet'], 'Three neighbouring hydrogens on the CH3 give 3 + 1 = 4 lines.', T.det);
add('Tetramethylsilane (TMS) is used in NMR spectroscopy as:', 'A reference standard with a chemical shift of 0 ppm', ['A solvent for ionic compounds', 'An acid catalyst', 'A source of radio waves'], 'It is chemically inert, volatile and gives one sharp signal.', T.det);
add('The relative areas under the peaks (integration) in a 1H NMR spectrum tell us:', 'The relative numbers of hydrogen atoms in each environment', ['The molar mass', 'The number of carbon atoms', 'The melting point'], 'The area is proportional to the number of equivalent hydrogens.', T.det);
add('UV-visible spectroscopy is especially useful for detecting:', 'Conjugated systems, such as alternating double bonds', ['Alkanes', 'Saturated alcohols', 'Ethers'], 'More conjugation moves the absorption towards longer wavelengths.', T.det);

// ---------------- chemical kinetics
add('The rate of a chemical reaction is defined as:', 'The change in concentration of a reactant or product per unit time', ['The total mass of the products', 'The temperature of the mixture', 'The volume of the container'], 'The units are usually mol dm⁻³ s⁻¹.', T.kin);
add('For the reaction A → products, the rate law is rate = k[A]². The order of reaction with respect to A is:', 'Second order', ['First order', 'Zero order', 'Third order'], 'The order is the power of the concentration in the rate law.', T.kin);
add('If the rate law is rate = k[A][B]², the overall order of the reaction is:', '3', ['2', '1', '5'], 'The overall order is the sum of the powers: 1 + 2 = 3.', T.kin);
chk(1 + 2, 3);
add('The units of the rate constant of a first-order reaction are:', 's⁻¹', ['mol dm⁻³ s⁻¹', 'dm³ mol⁻¹ s⁻¹', 'mol² dm⁻⁶ s⁻¹'], 'k = rate ÷ concentration, which is (mol dm⁻³ s⁻¹) ÷ (mol dm⁻³) = s⁻¹.', T.kin);
add('The units of the rate constant of a second-order reaction are:', 'dm³ mol⁻¹ s⁻¹', ['s⁻¹', 'mol dm⁻³ s⁻¹', 'dm⁶ mol⁻² s⁻¹'], 'k = rate ÷ concentration², which gives dm³ mol⁻¹ s⁻¹.', T.kin);
add('The units of the rate constant of a zero-order reaction are:', 'mol dm⁻³ s⁻¹', ['s⁻¹', 'dm³ mol⁻¹ s⁻¹', 'No units'], 'For zero order the rate equals k.', T.kin);
add('For a reaction that is second order in A, doubling the concentration of A makes the rate:', 'Four times as great', ['Twice as great', 'Unchanged', 'Eight times as great'], 'Rate is proportional to [A]², and 2² = 4.', T.kin);
add('For a reaction that is first order in B, tripling the concentration of B makes the rate:', 'Three times as great', ['Nine times as great', 'Unchanged', 'Six times as great'], 'Rate is proportional to [B].', T.kin);
add('A reaction is zero order in A. Doubling [A] makes the rate:', 'Unchanged', ['Twice as great', 'Half as great', 'Four times as great'], 'The rate does not depend on the concentration of A.', T.kin);
add('In an experiment, doubling [X] with [Y] constant doubles the rate. Doubling [Y] with [X] constant makes the rate four times as great. The rate law is:', 'rate = k[X][Y]²', ['rate = k[X]²[Y]', 'rate = k[X][Y]', 'rate = k[X]²[Y]²'], 'The order is 1 in X and 2 in Y.', T.kin);
add('The half-life of a first-order reaction with rate constant k is given by:', 't½ = 0.693 / k', ['t½ = 1 / (k[A]₀)', 't½ = [A]₀ / 2k', 't½ = k / 0.693'], 'The half-life of a first-order reaction is independent of the initial concentration.', T.kin);
add('A first-order reaction has a rate constant of 0.0231 min⁻¹. Its half-life is about:', '30 min', ['3 min', '60 min', '0.016 min'], 't½ = 0.693 ÷ 0.0231 = 30 min.', T.kin);
chk(0.693 / 0.0231, 30);
add('A first-order reaction has k = 0.0693 s⁻¹. The fraction of the reactant remaining after 30 s is:', '1/8', ['1/2', '1/4', '1/16'], 'The half-life is 0.693 ÷ 0.0693 = 10 s, so 30 s is three half-lives, and (1/2)³ = 1/8.', T.kin);
chk(0.693 / 0.0693, 10);
add('A first-order reaction is 75% complete in 40 minutes. Its half-life is:', '20 min', ['10 min', '40 min', '80 min'], '75% complete means 25% remains, which is two half-lives. So t½ = 40 ÷ 2 = 20 min.', T.kin);
add('For a zero-order reaction with [A]₀ = 0.80 mol dm⁻³ and k = 0.02 mol dm⁻³ s⁻¹, the concentration of A after 20 s is:', '0.40 mol dm⁻³', ['0.80 mol dm⁻³', '0.20 mol dm⁻³', '0.78 mol dm⁻³'], '[A] = [A]₀ - kt = 0.80 - 0.02 × 20 = 0.40.', T.kin);
chk(0.80 - 0.02 * 20, 0.40);
add('The half-life of a second-order reaction with k = 0.5 dm³ mol⁻¹ s⁻¹ and [A]₀ = 0.20 mol dm⁻³ is:', '10 s', ['2 s', '1.4 s', '20 s'], 't½ = 1 ÷ (k[A]₀) = 1 ÷ (0.5 × 0.20) = 10 s.', T.kin);
chk(1 / (0.5 * 0.2), 10);
add('A plot of ln[A] against time gives a straight line for a:', 'First-order reaction', ['Zero-order reaction', 'Second-order reaction', 'Reaction of any order'], 'The slope is -k.', T.kin);
add('A plot of 1/[A] against time gives a straight line for a:', 'Second-order reaction', ['First-order reaction', 'Zero-order reaction', 'Third-order reaction only'], 'The slope is k.', T.kin);
add('A plot of [A] against time that is a straight line with a negative slope indicates a:', 'Zero-order reaction', ['First-order reaction', 'Second-order reaction', 'Reaction that is complete'], 'The slope is -k.', T.kin);
add('According to collision theory, a reaction occurs when particles collide with:', 'Sufficient energy and the correct orientation', ['Any energy', 'Low energy only', 'The same speed'], 'The minimum energy needed is the activation energy.', T.kin);
add('Raising the temperature increases the rate of reaction mainly because:', 'A larger fraction of molecules have energy equal to or greater than the activation energy', ['The activation energy decreases', 'The molecules become smaller', 'The concentration decreases'], 'The Boltzmann distribution shifts to higher energies.', T.kin);
add('A catalyst increases the rate of reaction by:', 'Providing an alternative pathway with a lower activation energy', ['Increasing the temperature', 'Increasing the concentration of reactants', 'Changing the equilibrium position'], 'The catalyst is not used up.', T.kin);
add('The Arrhenius equation is:', 'k = A e^(-Ea/RT)', ['k = A e^(Ea/RT)', 'k = A / (Ea RT)', 'k = Ea / (A RT)'], 'It shows that k increases as temperature rises or as Ea falls.', T.kin);
add('A plot of ln k against 1/T has a slope of -6000 K. The activation energy is about (R = 8.314 J mol⁻¹ K⁻¹):', '49.9 kJ mol⁻¹', ['6.0 kJ mol⁻¹', '0.72 kJ mol⁻¹', '499 kJ mol⁻¹'], 'Slope = -Ea/R, so Ea = 6000 × 8.314 = 49 884 J mol⁻¹, about 49.9 kJ mol⁻¹.', T.kin);
chk(6000 * 8.314 / 1000, 49.884, 1e-3);
add('The rate-determining step of a reaction mechanism is:', 'The slowest step', ['The fastest step', 'The first step always', 'The last step always'], 'It controls the overall rate.', T.kin);
add('For a reaction that occurs in two steps, the step with the highest activation energy is generally:', 'The rate-determining step', ['The fastest step', 'The step with no transition state', 'The step involving the catalyst only'], 'A higher barrier means slower progress through that step.', T.kin);
add('The molecularity of an elementary step in which two molecules collide is:', 'Bimolecular', ['Unimolecular', 'Termolecular', 'Zero'], 'Molecularity is the number of species colliding in an elementary step.', T.kin);
add('For an elementary step, the order of reaction is:', 'Equal to its molecularity', ['Always zero', 'Always one', 'Unrelated to the molecularity'], 'The rate law of an elementary step follows from its stoichiometry.', T.kin);
add('The overall rate law of a reaction is determined by:', 'Experiment', ['The balanced equation only', 'The colour of reactants', 'The physical state only'], 'The orders cannot be read off the stoichiometry unless the reaction is an elementary step.', T.kin);
add('Which factor does NOT change the rate constant k of a reaction?', 'The concentration of reactants', ['Temperature', 'Presence of a catalyst', 'The activation energy'], 'The rate constant depends on temperature and on the reaction, but not on concentration.', T.kin);
add('In the reaction 2N2O5 → 4NO2 + O2, the rate of disappearance of N2O5 is 0.040 mol dm⁻³ s⁻¹. The rate of formation of NO2 is:', '0.080 mol dm⁻³ s⁻¹', ['0.020 mol dm⁻³ s⁻¹', '0.040 mol dm⁻³ s⁻¹', '0.160 mol dm⁻³ s⁻¹'], 'Two moles of N2O5 give four moles of NO2, so NO2 forms twice as fast: 2 × 0.040 = 0.080.', T.kin);
chk(2 * 0.040, 0.080);
add('The rate of formation of oxygen in the same reaction (2N2O5 → 4NO2 + O2) when N2O5 disappears at 0.040 mol dm⁻³ s⁻¹ is:', '0.020 mol dm⁻³ s⁻¹', ['0.040 mol dm⁻³ s⁻¹', '0.080 mol dm⁻³ s⁻¹', '0.010 mol dm⁻³ s⁻¹'], 'One mole of O2 forms for every two moles of N2O5 lost, so the rate is 0.040 ÷ 2 = 0.020.', T.kin);
chk(0.040 / 2, 0.020);
add('Increasing the surface area of a solid reactant increases the rate because:', 'More particles are exposed and the collision frequency increases', ['The activation energy decreases', 'The solid becomes a gas', 'The temperature falls'], 'A powdered solid reacts faster than a lump.', T.kin);
add('Which of the following will NOT speed up the reaction between magnesium and dilute hydrochloric acid?', 'Using a larger piece of magnesium ribbon', ['Using magnesium powder', 'Warming the acid', 'Using more concentrated acid'], 'A larger piece has a smaller surface area for the same mass.', T.kin);
add('A heterogeneous catalyst is one that:', 'Is in a different phase from the reactants', ['Is in the same phase as the reactants', 'Is used up in the reaction', 'Always dissolves in the mixture'], 'Iron in the Haber process is a solid catalyst for gaseous reactants.', T.kin);
add('The transition state of a reaction is:', 'The highest-energy arrangement of atoms along the reaction pathway', ['A stable intermediate that can be isolated', 'The final product', 'The reactants'], 'It cannot be isolated, unlike an intermediate.', T.kin);
add('A reaction intermediate differs from a transition state because an intermediate:', 'Lies in an energy minimum between two steps and has a finite lifetime', ['Is the highest point on the energy profile', 'Is never formed', 'Is always a stable product'], 'It appears as a valley on the reaction profile.', T.kin);
add('The initial rate method determines the order of reaction by:', 'Varying the initial concentration of one reactant at a time and noting how the initial rate changes', ['Measuring the colour of the products', 'Weighing the reactants', 'Changing the temperature of the apparatus'], 'The order with respect to each reactant is found separately.', T.kin);

module.exports = out;
