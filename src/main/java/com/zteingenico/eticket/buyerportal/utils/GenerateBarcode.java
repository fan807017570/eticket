package com.zteingenico.eticket.buyerportal.utils;

import java.awt.image.BufferedImage;
import java.io.File;
import java.io.FileOutputStream;
import java.io.IOException;
import java.io.OutputStream;

import javax.imageio.ImageIO;

import com.google.zxing.BarcodeFormat;
import com.google.zxing.MultiFormatWriter;
import com.google.zxing.WriterException;
import com.google.zxing.common.BitMatrix;
import com.zteingenico.eticket.buyerportal.exception.BarcodeException;

public class GenerateBarcode {

	private static final int BLACK = 0xff000000; 
	private static final int WHITE = 0xFFFFFFFF;
	
	private MultiFormatWriter writer;
	
	public GenerateBarcode() {
		writer = new MultiFormatWriter();
	}
	
	private BufferedImage createBufferedImage(
			String contents,
			BarcodeFormat format,
			BarcodeImageFormat imageFormat,
			int width,
			int height) throws WriterException {
		
		BitMatrix matrix = writer.encode(
				contents, 
				format, 
				width, 
				height);
		BufferedImage image = null;
		if(imageFormat == BarcodeImageFormat.jpeg) {
			image = new BufferedImage(
					width, 
					height, 
					BufferedImage.TYPE_INT_RGB);
		} else {
			image = new BufferedImage(
					width, 
					height, 
					BufferedImage.TYPE_INT_ARGB);
		}
		
		for(int x = 0; x < width; x++) {
			for (int y = 0; y < height; y++) {
				image.setRGB(x, y, matrix.get(x, y) == true ? BLACK : WHITE);
			}
		}
		
		return image;
	}
	
	public void outputBarcode(String contents,
			BarcodeImageFormat imageFormat,
			int width,
			int height,
			BarcodeFormat format,
			OutputStream os) throws WriterException, IOException {
			BufferedImage image = createBufferedImage(
					contents, 
					format, 
					imageFormat, 
					width, 
					height);
			ImageIO.write(image, imageFormat.name(), os);
	}
	
	public void createBarcodeFile(String contents,
			BarcodeFormat format,
			int width,
			int height,
			BarcodeImageFormat imageFormat,
			String fileName) {
		try {
			File file = new File(fileName);
			if(file.exists()) {
				file.delete();
			}
			file.createNewFile();
			OutputStream os = new FileOutputStream(file);
//			outputBarcode(
//					contents, 
//					format, 
//					width, 
//					height, 
//					imageFormat, 
//					os);
			os.flush();
			os.close();
		} catch(Exception e) {
			throw new BarcodeException("GenerateBarcode createBarcodeFile exception.", e);
		}
	}
	
	public static void main(String[] args) {
		GenerateBarcode generator = new GenerateBarcode();
		String contents = "A13343434AAAAAAA";
		int width = 300;
		int height = 300;
		BarcodeImageFormat imageFormat = BarcodeImageFormat.jpeg;
		BarcodeFormat format  = BarcodeFormat.QR_CODE;
		String fileName = format + "." + imageFormat;
		generator.createBarcodeFile(contents, format, width, height, imageFormat, fileName);
	}
}
